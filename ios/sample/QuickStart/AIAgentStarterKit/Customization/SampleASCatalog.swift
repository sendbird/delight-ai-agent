//
//  SampleASCatalog.swift
//  QuickStart
//
//  Created by Tez Park on 8/31/26.
//
//  The case catalog the app fetches for itself.
//
//  Why the app fetches it instead of receiving it in the template payload: a
//  template's HTTP response body is handed to the agent as a tool result, so a long
//  catalog would enter the model context on every turn even though only the screen
//  reads it. The payload carries the catalog address and version instead.
//

#if INTERNAL_SAMPLE_CUSTOM_TEMPLATE
import Foundation

// MARK: - Model

/// The document the catalog address returns.
struct SampleASCatalog: Decodable {

    /// One selectable AS case. The four category fields form the pick path.
    struct Case: Decodable {
        let caseId: String
        let process: String
        let product: String
        let faultType: String
        let symptom: String

        enum CodingKeys: String, CodingKey {
            case caseId = "case_id"
            case process
            case product
            case faultType = "fault_type"
            case symptom
        }
    }

    let title: String?
    let description: String?
    let catalogVersion: String?
    let submitLabel: String?
    let fallbackText: String?
    let cases: [Case]

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case catalogVersion = "catalog_version"
        case submitLabel = "submit_label"
        case fallbackText = "fallback_text"
        case cases
    }

    /// Distinct values for `level`, keeping the catalog order, narrowed by `picked`.
    ///
    /// - Parameters:
    ///   - level: 0 process, 1 product, 2 fault type, 3 symptom.
    ///   - picked: Values already chosen for the levels before `level`.
    func options(at level: Int, picked: [String]) -> [String] {
        let matching = self.cases.filter { entry in
            for (index, value) in picked.enumerated() where Self.value(of: entry, at: index) != value {
                return false
            }
            return true
        }

        var seen = Set<String>()
        return matching.compactMap { entry -> String? in
            let value = Self.value(of: entry, at: level)
            return seen.insert(value).inserted ? value : nil
        }
    }

    /// The single case matching a complete pick path, or `nil` while it is incomplete.
    func matchingCase(for picked: [String]) -> Case? {
        guard picked.count == Self.levelLabels.count else { return nil }
        return self.cases.first { entry in
            for (index, value) in picked.enumerated() where Self.value(of: entry, at: index) != value {
                return false
            }
            return true
        }
    }

    static let levelLabels = ["공간", "제품", "이상 유형", "증상"]

    static let levelPlaceholders = [
        "공간을 선택해 주세요.",
        "제품을 선택해 주세요.",
        "어떤 이상인지 선택해 주세요.",
        "증상을 선택해 주세요."
    ]

    private static func value(of entry: Case, at level: Int) -> String {
        switch level {
        case 0: return entry.process
        case 1: return entry.product
        case 2: return entry.faultType
        default: return entry.symptom
        }
    }
}

// MARK: - Loader

/// Fetches the catalog once per address and version, then serves it from memory.
///
/// Every message cell showing the selector asks for the same catalog, so without the
/// cache a conversation with several cards would repeat the same request.
enum SampleASCatalogLoader {

    private static var cache: [String: SampleASCatalog] = [:]
    private static var pending: [String: [(SampleASCatalog?) -> Void]] = [:]

    /// Debug stub. When set, no request is made and this JSON is decoded instead.
    static var stubJSON: String?

    static func cacheKey(url: String, version: String?) -> String {
        "\(url)#\(version ?? "-")"
    }

    static func cached(url: String, version: String?) -> SampleASCatalog? {
        self.cache[self.cacheKey(url: url, version: version)]
    }

    /// Main queue only, so the callers do not need to hop threads.
    static func load(
        url: String,
        version: String?,
        completion: @escaping (SampleASCatalog?) -> Void
    ) {
        let key = self.cacheKey(url: url, version: version)

        if let catalog = self.cache[key] {
            completion(catalog)
            return
        }

        if let stubJSON = self.stubJSON {
            let catalog = Self.decode(stubJSON.data(using: .utf8))
            if let catalog { self.cache[key] = catalog }
            completion(catalog)
            return
        }

        if self.pending[key] != nil {
            self.pending[key]?.append(completion)
            return
        }
        self.pending[key] = [completion]

        guard let requestURL = URL(string: url) else {
            self.finish(key: key, catalog: nil)
            return
        }

        let task = URLSession.shared.dataTask(with: requestURL) { data, _, _ in
            let catalog = Self.decode(data)
            DispatchQueue.main.async {
                // A failure is not cached, so the retry button can try again.
                if let catalog { self.cache[key] = catalog }
                self.finish(key: key, catalog: catalog)
            }
        }
        task.resume()
    }

    private static func finish(key: String, catalog: SampleASCatalog?) {
        let handlers = self.pending.removeValue(forKey: key) ?? []
        handlers.forEach { $0(catalog) }
    }

    private static func decode(_ data: Data?) -> SampleASCatalog? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(SampleASCatalog.self, from: data)
    }
}

// MARK: - Debug stub

extension SampleASCatalogLoader {

    /// A small catalog, enough to exercise all four levels without a server.
    static let debugStubJSON = """
    {
      "schema_version": "2.0",
      "type": "as_selector",
      "stage": "catalog",
      "title": "어떤 제품에 문제가 생기셨나요?",
      "description": "제품과 증상을 순서대로 선택하면 맞는 안내를 보여드려요.",
      "catalog_version": "2026-08-04T05:48:04Z",
      "submit_label": "선택완료",
      "fallback_text": "제품과 증상을 직접 입력해 주세요.",
      "cases": [
        { "case_id": "AS-0001", "process": "부엌", "product": "수납장/도어/상판",
          "fault_type": "작동이상", "symptom": "도어에서 경첩이 탈착되었을 시 조치방법" },
        { "case_id": "AS-0002", "process": "부엌", "product": "수납장/도어/상판",
          "fault_type": "작동이상", "symptom": "푸쉬철물 탈착 시 조치방법" },
        { "case_id": "AS-0003", "process": "부엌", "product": "수납장/도어/상판",
          "fault_type": "외관이상", "symptom": "도어의 높낮이가 맞지 않을 시 조치방법" },
        { "case_id": "AS-0005", "process": "부엌", "product": "수납장/도어/상판",
          "fault_type": "외관이상", "symptom": "도어 사이가 벌어졌을 시 조치방법" },
        { "case_id": "AS-0009", "process": "부엌", "product": "수납장/도어/상판",
          "fault_type": "냄새/오염/이염", "symptom": "인조대리석 얼룩 제거방법" },
        { "case_id": "AS-0011", "process": "부엌", "product": "후드",
          "fault_type": "작동이상", "symptom": "후드 필터망이 빠지지 않을 경우 해결방법" },
        { "case_id": "AS-0013", "process": "부엌", "product": "후드",
          "fault_type": "냄새/오염/이염", "symptom": "후드 필터망 세척방법" },
        { "case_id": "AS-0015", "process": "부엌", "product": "후드",
          "fault_type": "소음이상", "symptom": "후드 소음이 너무 심할 경우 조치방법" },
        { "case_id": "AS-0016", "process": "부엌", "product": "가스레인지/인덕션",
          "fault_type": "작동이상", "symptom": "가스레인지 불이 잘 안켜질때의 조치방법" },
        { "case_id": "AS-0022", "process": "부엌", "product": "가스레인지/인덕션",
          "fault_type": "작동이상", "symptom": "인덕션 에러코드 조치방법" },
        { "case_id": "AS-0029", "process": "부엌", "product": "수전",
          "fault_type": "작동이상", "symptom": "수전 온수가 나오지 않을 경우 조치방법" },
        { "case_id": "AS-0035", "process": "거실", "product": "소파",
          "fault_type": "작동이상", "symptom": "리클라이너 이상작동, 셀프 점검방법" },
        { "case_id": "AS-0044", "process": "거실", "product": "소파",
          "fault_type": "외관이상", "symptom": "소파 쿠션, 왜 꺼지는 걸까요?" },
        { "case_id": "AS-0048", "process": "거실", "product": "소파",
          "fault_type": "냄새/오염/이염", "symptom": "소파에서 냄새가 나요, 정상인가요?" },
        { "case_id": "AS-0051", "process": "거실", "product": "거실장",
          "fault_type": "작동이상", "symptom": "거실장 플랩도어가 고정이 안될때 조치방법" },
        { "case_id": "AS-0054", "process": "침실", "product": "침대",
          "fault_type": "작동이상", "symptom": "침대 프레임의 높이 조정방법" },
        { "case_id": "AS-0059", "process": "침실", "product": "침대",
          "fault_type": "소음이상", "symptom": "침대가 흔들리고 소음(마찰음)이 날때 조치방법" },
        { "case_id": "AS-0061", "process": "침실", "product": "화장대/서랍장",
          "fault_type": "작동이상", "symptom": "화장대 서랍 개폐 문제시 조치방법" },
        { "case_id": "AS-0081", "process": "욕실", "product": "세면대",
          "fault_type": "작동이상", "symptom": "세면대 배수가 안될때 조치방법" },
        { "case_id": "AS-0085", "process": "욕실", "product": "세면대",
          "fault_type": "외관이상", "symptom": "세면대 스크래치가 생겼을때 조치방법" },
        { "case_id": "AS-0089", "process": "욕실", "product": "양변기/비데",
          "fault_type": "작동이상", "symptom": "양변기 물탱크 물 안채워질때 조치방법" },
        { "case_id": "AS-0102", "process": "욕실", "product": "수전",
          "fault_type": "작동이상", "symptom": "샤워수전 수압이 약할때 조치방법" },
        { "case_id": "AS-0124", "process": "다이닝", "product": "식탁",
          "fault_type": "작동이상", "symptom": "식탁 흔들림 조치방법 [볼트형]" },
        { "case_id": "AS-0142", "process": "옷장/드레스룸", "product": "붙박이장",
          "fault_type": "작동이상", "symptom": "슬라이딩장 도어가 꽉 안닫혀요" }
      ],
      "total_cases": 24
    }
    """
}
#endif // INTERNAL_SAMPLE_CUSTOM_TEMPLATE
