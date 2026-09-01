//
//  SampleASGuideCardView.swift
//  QuickStart
//
//  Created by Tez Park on 8/31/26.
//
//  The second template: the guide for one case.
//
//  Unlike the selector, this payload does carry its content. It is one answer rather
//  than a catalog, so it is small enough to pass through the agent. Images are
//  referenced by URL and fetched by this view.
//

#if INTERNAL_SAMPLE_CUSTOM_TEMPLATE
import SendbirdAIAgentMessenger
import UIKit

final class SampleASGuideCardView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let cardCornerRadius: CGFloat = 12
        static let cardInset: CGFloat = 16
        static let sectionSpacing: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let blockCornerRadius: CGFloat = 8
        static let stepSpacing: CGFloat = 8
        static let stepNumberSize: CGFloat = 20
        static let stepNumberGap: CGFloat = 10
        static let imageAspectRatio: CGFloat = 0.75
        static let noticeInsetVertical: CGFloat = 10
        static let noticeInsetHorizontal: CGFloat = 12
        static let actionInsetVertical: CGFloat = 12
        static let actionInsetHorizontal: CGFloat = 16
    }

    // MARK: - Contract

    /// ```json
    /// {
    ///   "schema_version": "2.0",
    ///   "type": "as_guide",
    ///   "case_id": "AS-0001",
    ///   "title": "도어에서 경첩이 탈착되었을 시 조치방법",
    ///   "summary": "경첩 나사가 풀려서 생기는 경우가 많아요.",
    ///   "steps": [{ "text": "...", "image_url": "https://..." }],
    ///   "notice": "직접 조치가 어려우면 상담원을 연결해 드려요.",
    ///   "actions": [{ "label": "상담원 연결", "message": "상담원 연결해 주세요" }]
    /// }
    /// ```
    struct Payload: Decodable {
        struct Step: Decodable {
            let text: String
            let imageURL: String?

            enum CodingKeys: String, CodingKey {
                case text
                case imageURL = "image_url"
            }
        }

        struct Action: Decodable {
            let label: String
            let message: String
        }

        let type: String
        let caseId: String?
        let title: String
        let summary: String?
        let steps: [Step]
        let notice: String?
        let actions: [Action]?

        enum CodingKeys: String, CodingKey {
            case type
            case caseId = "case_id"
            case title
            case summary
            case steps
            case notice
            case actions
        }
    }

    static let payloadType = "as_guide"

    /// Sends a message to the conversation. Set by the host view.
    var onSend: ((String) -> Void)?
    /// Tells the host the card changed height. Set by the host view.
    var onHeightChange: (() -> Void)?

    // MARK: - Views

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.sectionSpacing
        // Off before `addSubview`, or UIKit pins this to a zero frame.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var didInstallConstraints = false
    /// See the selector card: the list reconfigures visible cells repeatedly while a
    /// message streams, so the height is only reported when it actually changed.
    private var lastReportedHeight: CGFloat = -1

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = Constants.cardCornerRadius
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = UIColor.separator.cgColor

        self.addSubview(self.contentStackView)
        self.installConstraintsIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    private func installConstraintsIfNeeded() {
        guard self.didInstallConstraints == false else { return }
        self.didInstallConstraints = true

        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.cardInset),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.cardInset),
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.cardInset),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.cardInset)
        ])
    }

    // MARK: - Configuration

    /// - Returns: `false` when the JSON is missing or not this template's payload.
    @discardableResult
    func configure(withContent content: String?) -> Bool {
        guard let data = content?.data(using: .utf8),
              let payload = try? JSONDecoder().decode(Payload.self, from: data),
              payload.type == Self.payloadType else {
            return false
        }

        self.rebuild(with: payload)
        return true
    }

    // MARK: - Rendering

    private func rebuild(with payload: Payload) {
        self.contentStackView.arrangedSubviews.forEach {
            self.contentStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        self.contentStackView.addArrangedSubview(
            self.makeLabel(payload.title, font: SBAFontSet.h2, color: .label)
        )
        if let summary = payload.summary {
            self.contentStackView.addArrangedSubview(
                self.makeLabel(summary, font: SBAFontSet.body3, color: .secondaryLabel)
            )
        }

        for (index, step) in payload.steps.enumerated() {
            self.contentStackView.addArrangedSubview(self.makeStepView(number: index + 1, step: step))
        }

        if let notice = payload.notice {
            self.contentStackView.addArrangedSubview(self.makeNoticeView(notice))
        }

        for action in payload.actions ?? [] {
            self.contentStackView.addArrangedSubview(self.makeActionButton(action))
        }

        if let caseId = payload.caseId {
            self.contentStackView.addArrangedSubview(
                self.makeCaseIdLabel(caseId)
            )
        }

        self.accessibilityElements = self.contentStackView.arrangedSubviews
        self.reportHeightIfChanged()
    }

    private func reportHeightIfChanged() {
        let inset = Constants.cardInset * 2
        let width = self.bounds.width > inset ? self.bounds.width - inset : 212
        let height = self.contentStackView.systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        guard abs(height - self.lastReportedHeight) > 0.5 else { return }
        self.lastReportedHeight = height
        self.onHeightChange?()
    }

    private func makeStepView(number: Int, step: Payload.Step) -> UIView {
        let numberLabel = self.makeLabel("\(number)", font: SBAFontSet.caption3, color: .white)
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = .tertiaryLabel
        numberLabel.layer.cornerRadius = Constants.stepNumberSize / 2
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.widthAnchor.constraint(equalToConstant: Constants.stepNumberSize),
            numberLabel.heightAnchor.constraint(equalToConstant: Constants.stepNumberSize)
        ])

        let textLabel = self.makeLabel(step.text, font: SBAFontSet.body3, color: .label)

        let headerStackView = UIStackView(arrangedSubviews: [numberLabel, textLabel])
        headerStackView.axis = .horizontal
        headerStackView.alignment = .top
        headerStackView.spacing = Constants.stepNumberGap

        let stepStackView = UIStackView(arrangedSubviews: [headerStackView])
        stepStackView.axis = .vertical
        stepStackView.alignment = .fill
        stepStackView.spacing = Constants.stepSpacing

        if let imageURL = step.imageURL {
            stepStackView.addArrangedSubview(self.makeStepImageView(urlString: imageURL))
        }

        stepStackView.isAccessibilityElement = true
        stepStackView.accessibilityLabel = "\(number)단계, \(step.text)"
        return stepStackView
    }

    /// A 4:3 box that fills in once the image arrives, so the card height does not jump
    /// twice per step.
    private func makeStepImageView(urlString: String) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemFill
        imageView.layer.cornerRadius = Constants.blockCornerRadius
        imageView.isAccessibilityElement = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.imageAspectRatio).isActive = true

        SampleASImageLoader.load(urlString: urlString) { [weak self, weak imageView] image in
            guard let image else { return }
            imageView?.image = image
            // The box is a fixed ratio, so the height does not change here. Reported
            // anyway in case a host changes that.
            self?.reportHeightIfChanged()
        }
        return imageView
    }

    private func makeNoticeView(_ text: String) -> UIView {
        let label = self.makeLabel(text, font: SBAFontSet.caption2, color: .secondaryLabel)

        let container = UIView()
        container.backgroundColor = .tertiarySystemFill
        container.layer.cornerRadius = Constants.blockCornerRadius
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.noticeInsetHorizontal),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.noticeInsetHorizontal),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.noticeInsetVertical),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.noticeInsetVertical)
        ])
        return container
    }

    /// A label inside a `UIControl`.
    ///
    /// `UIButton.Configuration` would be shorter but it needs iOS 15, and this target is
    /// iOS 14. The older content inset properties are deprecated, so the padding comes
    /// from constraints instead.
    private func makeActionButton(_ action: Payload.Action) -> UIView {
        let label = self.makeLabel(action.label, font: SBAFontSet.button1, color: AIAgentMessenger.currentColorSet.primary.main)
        label.textAlignment = .center

        let control = UIControl()
        control.backgroundColor = .tertiarySystemFill
        control.layer.cornerRadius = Constants.blockCornerRadius
        control.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: Constants.actionInsetHorizontal),
            label.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -Constants.actionInsetHorizontal),
            label.topAnchor.constraint(equalTo: control.topAnchor, constant: Constants.actionInsetVertical),
            label.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -Constants.actionInsetVertical)
        ])

        control.isAccessibilityElement = true
        control.accessibilityTraits = .button
        control.accessibilityLabel = action.label
        control.addAction(
            UIAction { [weak self] _ in self?.onSend?(action.message) },
            for: .touchUpInside
        )
        return control
    }

    private func makeCaseIdLabel(_ caseId: String) -> UILabel {
        let label = self.makeLabel("접수 코드 \(caseId)", font: SBAFontSet.caption4, color: .tertiaryLabel)
        label.textAlignment = .right
        return label
    }

    /// Uses the SDK font set so the card matches the rest of the conversation. See the
    /// selector card for why `adjustsFontForContentSizeCategory` is left off.
    private func makeLabel(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
}

// MARK: - Image loading

/// Keeps decoded step images in memory for the session.
///
/// The SDK does not expose its own image cache, so a custom template that shows images
/// has to bring one. Without it every cell reuse re-downloads.
enum SampleASImageLoader {

    private static var cache: [String: UIImage] = [:]
    private static var pending: [String: [(UIImage?) -> Void]] = [:]

    /// Main queue only.
    ///
    /// Requests for the same address are folded into one. The message cell builds a fresh
    /// template view on every reconfigure, so without this a scroll or a streaming update
    /// starts another download for a URL already in flight.
    static func load(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let image = self.cache[urlString] {
            completion(image)
            return
        }

        if self.pending[urlString] != nil {
            self.pending[urlString]?.append(completion)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        self.pending[urlString] = [completion]

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async {
                // A failure is not cached, so a later card can try again.
                if let image { self.cache[urlString] = image }
                let handlers = self.pending.removeValue(forKey: urlString) ?? []
                handlers.forEach { $0(image) }
            }
        }
        task.resume()
    }
}
#endif // INTERNAL_SAMPLE_CUSTOM_TEMPLATE
