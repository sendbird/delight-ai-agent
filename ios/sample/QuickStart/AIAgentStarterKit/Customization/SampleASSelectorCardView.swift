//
//  SampleASSelectorCardView.swift
//  QuickStart
//
//  Created by Tez Park on 8/31/26.
//
//  The first template: a category selector.
//
//  The payload carries only the catalog address and version. This view fetches the
//  catalog itself and narrows the pick over four levels, down to one case id. That id
//  is what the agent needs in order to look the guide up.
//

#if INTERNAL_SAMPLE_CUSTOM_TEMPLATE
import SendbirdAIAgentMessenger
import UIKit

final class SampleASSelectorCardView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let cardCornerRadius: CGFloat = 12
        static let cardInset: CGFloat = 16
        static let sectionSpacing: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let fieldCornerRadius: CGFloat = 8
        static let fieldInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        static let optionInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
        static let optionListInset: CGFloat = 4
        static let chevronSize: CGFloat = 14
        static let rowSpacing: CGFloat = 8
        static let submitInsetVertical: CGFloat = 14
        static let submitInsetHorizontal: CGFloat = 16
        static let loadingInset: CGFloat = 8
    }

    // MARK: - Contract

    /// The small payload the agent sends. The catalog is not in here.
    ///
    /// ```json
    /// {
    ///   "schema_version": "2.0",
    ///   "type": "as_selector",
    ///   "stage": "catalog",
    ///   "title": "어떤 제품에 문제가 생기셨나요?",
    ///   "catalog_url": "https://.../as/catalog.json",
    ///   "catalog_version": "2026-08-04T05:48:04Z"
    /// }
    /// ```
    struct Payload: Decodable {
        let type: String
        let title: String?
        let description: String?
        let submitLabel: String?
        let fallbackText: String?
        let catalogURL: String
        let catalogVersion: String?

        enum CodingKeys: String, CodingKey {
            case type
            case title
            case description
            case submitLabel = "submit_label"
            case fallbackText = "fallback_text"
            case catalogURL = "catalog_url"
            case catalogVersion = "catalog_version"
        }
    }

    static let payloadType = "as_selector"

    /// Sends a message to the conversation. Set by the host view.
    var onSend: ((String) -> Void)?
    /// Tells the host the card changed height. Set by the host view.
    var onHeightChange: (() -> Void)?

    /// The pick that was last submitted from a card, per message.
    ///
    /// Static because the view is recreated whenever the cell is reconfigured, so an
    /// instance property would forget it. Keyed on the message, since a card belongs to
    /// one turn.
    ///
    /// Known gap: the send can be refused downstream — while the input is locked, or
    /// after the conversation closes — and nothing reports that back, so the card can
    /// lock with nothing sent. Closing that needs a way to learn whether a send was
    /// accepted, which the SDK does not expose yet. The picked path is stored rather
    /// than a flag so the fix has somewhere to land, but today a locked card stays
    /// locked.
    private static var submittedPickByMessageId: [Int64: [String]] = [:]

    /// One card's picks.
    private struct Progress {
        var picked: [String]
        var expandedLevel: Int?
    }

    /// What the user picked, kept per message.
    ///
    /// The cell builds a fresh card every time it is reconfigured, so scrolling the card
    /// off screen and back would otherwise clear the selection. The message id is the key
    /// because it is the only thing that stays the same across those rebuilds.
    ///
    /// Grows with the number of messages that carried a card, and is never pruned. That is
    /// fine for a sample; a host that keeps very long conversations open should bound it.
    private static var progressByMessageId: [Int64: Progress] = [:]

    /// Set by the host view before `configure(withContent:)`.
    var messageId: Int64 = 0

    // MARK: - State

    private enum LoadState {
        case loading
        case loaded(SampleASCatalog)
        case failed
    }

    private var payload: Payload?
    private var loadState: LoadState = .loading
    private var picked: [String] = []
    private var expandedLevel: Int?

    private var catalog: SampleASCatalog? {
        if case .loaded(let catalog) = self.loadState { return catalog }
        return nil
    }

    /// True while the current pick is the one that was last submitted.
    private var isSubmitted: Bool {
        guard self.messageId != 0,
              let submitted = Self.submittedPickByMessageId[self.messageId] else { return false }
        return submitted == self.picked
    }

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
    /// Height last reported to the host. Rebuilds happen on every reconfigure, and the
    /// list reconfigures visible cells repeatedly while a message streams, so reporting
    /// unconditionally invalidates the layout far more often than the content changes.
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

        self.payload = payload

        let progress = Self.progressByMessageId[self.messageId]
        self.picked = progress?.picked ?? []
        self.expandedLevel = progress?.expandedLevel

        if let catalog = SampleASCatalogLoader.cached(url: payload.catalogURL, version: payload.catalogVersion) {
            self.loadState = .loaded(catalog)
        } else {
            self.loadState = .loading
            self.loadCatalog(for: payload)
        }

        self.rebuild()
        return true
    }

    private func loadCatalog(for payload: Payload) {
        let requestedKey = SampleASCatalogLoader.cacheKey(url: payload.catalogURL, version: payload.catalogVersion)

        SampleASCatalogLoader.load(url: payload.catalogURL, version: payload.catalogVersion) { [weak self] catalog in
            guard let self = self else { return }
            // The cell may have been reused for another message while the request ran.
            guard let current = self.payload,
                  SampleASCatalogLoader.cacheKey(url: current.catalogURL, version: current.catalogVersion) == requestedKey
            else { return }

            self.loadState = catalog.map { LoadState.loaded($0) } ?? .failed
            self.rebuild()
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
    }

    // MARK: - Rendering

    private func rebuild() {
        self.contentStackView.arrangedSubviews.forEach {
            self.contentStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard let payload = self.payload else {
            self.contentStackView.addArrangedSubview(
                self.makeLabel("지금은 이 안내를 표시할 수 없어요.", font: SBAFontSet.body3, color: .secondaryLabel)
            )
            self.finishRebuild()
            return
        }

        let title = payload.title ?? self.catalog?.title
        if let title {
            self.contentStackView.addArrangedSubview(self.makeLabel(title, font: SBAFontSet.h2, color: .label))
        }
        if let description = payload.description ?? self.catalog?.description {
            self.contentStackView.addArrangedSubview(
                self.makeLabel(description, font: SBAFontSet.body3, color: .secondaryLabel)
            )
        }

        switch self.loadState {
        case .loading:
            self.contentStackView.addArrangedSubview(self.makeLoadingView())

        case .failed:
            self.contentStackView.addArrangedSubview(
                self.makeLabel(
                    payload.fallbackText ?? "항목을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.",
                    font: SBAFontSet.body3,
                    color: .secondaryLabel
                )
            )
            self.contentStackView.addArrangedSubview(self.makeRetryButton())

        case .loaded(let catalog):
            self.buildLevels(catalog: catalog, payload: payload)
        }

        self.finishRebuild()
    }

    private func buildLevels(catalog: SampleASCatalog, payload: Payload) {
        // Every answered level plus the next one. A submitted card stops at what was
        // picked, so no empty row invites another tap.
        let visibleCount = self.isSubmitted
            ? self.picked.count
            : min(self.picked.count + 1, SampleASCatalog.levelLabels.count)

        for level in 0..<visibleCount {
            let options = catalog.options(at: level, picked: Array(self.picked.prefix(level)))
            guard options.isEmpty == false else { continue }

            self.contentStackView.addArrangedSubview(self.makeFieldRow(level: level, options: options))

            if self.isSubmitted == false, self.expandedLevel == level {
                self.contentStackView.addArrangedSubview(self.makeOptionList(level: level, options: options))
            }
        }

        let matched = catalog.matchingCase(for: self.picked)
        if let matched {
            self.contentStackView.addArrangedSubview(self.makeCaseIdLabel(matched.caseId))
        }

        self.contentStackView.addArrangedSubview(
            self.makeSubmitButton(
                title: payload.submitLabel ?? catalog.submitLabel ?? "선택완료",
                matchedCase: matched
            )
        )
    }

    private func finishRebuild() {
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

    // MARK: - Rows

    private func makeFieldRow(level: Int, options: [String]) -> UIView {
        let isPicked = level < self.picked.count
        let isLocked = self.isSubmitted
        let text = isPicked ? self.picked[level] : SampleASCatalog.levelPlaceholders[level]

        let textColor: UIColor = isLocked ? .secondaryLabel : (isPicked ? .label : .tertiaryLabel)
        let label = self.makeLabel(text, font: SBAFontSet.body3, color: textColor)
        label.numberOfLines = 2

        let chevronView = UIImageView(
            image: UIImage(systemName: self.expandedLevel == level ? "chevron.up" : "chevron.down")
        )
        chevronView.tintColor = .tertiaryLabel
        chevronView.isHidden = isLocked
        chevronView.contentMode = .scaleAspectFit
        chevronView.setContentHuggingPriority(.required, for: .horizontal)

        let rowStackView = UIStackView(arrangedSubviews: [label, chevronView])
        rowStackView.axis = .horizontal
        rowStackView.alignment = .center
        rowStackView.spacing = Constants.rowSpacing
        rowStackView.isLayoutMarginsRelativeArrangement = true
        rowStackView.layoutMargins = Constants.fieldInsets
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        // Without this the stack is the hit-test result and the row never taps.
        // A `UILabel` is fine on its own because it defaults to interaction off,
        // but a `UIStackView` does not.
        rowStackView.isUserInteractionEnabled = false

        let container = UIControl()
        container.isEnabled = isLocked == false
        container.backgroundColor = isLocked ? .tertiarySystemFill : .clear
        container.layer.cornerRadius = Constants.fieldCornerRadius
        container.layer.borderWidth = Constants.borderWidth
        container.layer.borderColor = UIColor.separator.cgColor
        container.addSubview(rowStackView)
        NSLayoutConstraint.activate([
            rowStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rowStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rowStackView.topAnchor.constraint(equalTo: container.topAnchor),
            rowStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: Constants.chevronSize)
        ])

        container.isAccessibilityElement = true
        container.accessibilityTraits = isLocked ? .staticText : .button
        container.accessibilityLabel = "\(SampleASCatalog.levelLabels[level]), \(text)"
        container.addAction(
            UIAction { [weak self] _ in self?.toggleLevel(level) },
            for: .touchUpInside
        )
        return container
    }

    private func makeOptionList(level: Int, options: [String]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0

        for option in options {
            let row = self.makeTappableRow(
                text: option,
                font: SBAFontSet.body3,
                color: .label,
                insets: Constants.optionInsets
            ) { [weak self] in
                self?.pick(option, at: level)
            }
            stackView.addArrangedSubview(row)
        }

        let container = UIView()
        container.backgroundColor = .tertiarySystemFill
        container.layer.cornerRadius = Constants.fieldCornerRadius
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.optionListInset),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.optionListInset)
        ])
        return container
    }

    /// A tappable row built from a label inside a `UIControl`.
    ///
    /// `UIButton.Configuration` would be shorter but it needs iOS 15, and this target
    /// is iOS 14. The older content inset properties are deprecated, so the padding
    /// comes from constraints instead.
    private func makeTappableRow(
        text: String,
        font: UIFont,
        color: UIColor,
        insets: UIEdgeInsets,
        action: @escaping () -> Void
    ) -> UIControl {
        let label = self.makeLabel(text, font: font, color: color)

        let control = UIControl()
        control.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: insets.left),
            label.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -insets.right),
            label.topAnchor.constraint(equalTo: control.topAnchor, constant: insets.top),
            label.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -insets.bottom)
        ])

        control.isAccessibilityElement = true
        control.accessibilityTraits = .button
        control.accessibilityLabel = text
        control.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return control
    }

    private func makeCaseIdLabel(_ caseId: String) -> UILabel {
        let label = self.makeLabel("접수 코드 \(caseId)", font: SBAFontSet.caption4, color: .secondaryLabel)
        label.textAlignment = .right
        return label
    }

    private func makeSubmitButton(title: String, matchedCase: SampleASCatalog.Case?) -> UIView {
        let isSubmitted = self.isSubmitted
        let isEnabled = matchedCase != nil && isSubmitted == false
        let text = isSubmitted ? "접수했어요" : title

        let label = self.makeLabel(text, font: SBAFontSet.button1, color: isEnabled ? .white : .tertiaryLabel)
        label.textAlignment = .center

        let control = UIControl()
        control.isEnabled = isEnabled
        control.backgroundColor = isEnabled ? AIAgentMessenger.currentColorSet.primary.main : .tertiarySystemFill
        control.layer.cornerRadius = Constants.fieldCornerRadius
        control.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: Constants.submitInsetHorizontal),
            label.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -Constants.submitInsetHorizontal),
            label.topAnchor.constraint(equalTo: control.topAnchor, constant: Constants.submitInsetVertical),
            label.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -Constants.submitInsetVertical)
        ])

        control.isAccessibilityElement = true
        control.accessibilityTraits = isEnabled ? .button : [.button, .notEnabled]
        control.accessibilityLabel = text
        control.addAction(UIAction { [weak self] _ in self?.submit() }, for: .touchUpInside)
        return control
    }

    private func makeLoadingView() -> UIView {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.startAnimating()
        indicatorView.isAccessibilityElement = true
        indicatorView.accessibilityLabel = "항목을 불러오는 중"

        let container = UIView()
        container.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            indicatorView.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.loadingInset),
            indicatorView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.loadingInset),
            indicatorView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor)
        ])
        return container
    }

    private func makeRetryButton() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("다시 시도", for: .normal)
        button.titleLabel?.font = SBAFontSet.body3
        button.contentHorizontalAlignment = .leading
        button.addAction(UIAction { [weak self] _ in self?.retry() }, for: .touchUpInside)
        return button
    }

    /// Uses the SDK font set so the card matches the rest of the conversation and picks
    /// up a host app's `SBAFontSet.fontFamily` override. These fonts are already Dynamic
    /// Type scaled, so `adjustsFontForContentSizeCategory` is left off to avoid scaling
    /// twice; the card restyles on the next reconfigure.
    private func makeLabel(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    // MARK: - Actions

    private func toggleLevel(_ level: Int) {
        guard self.isSubmitted == false else { return }
        self.expandedLevel = self.expandedLevel == level ? nil : level
        self.saveProgress()
        self.rebuild()
    }

    private func pick(_ option: String, at level: Int) {
        guard self.isSubmitted == false else { return }
        // Picking a level again drops everything below it.
        self.picked = Array(self.picked.prefix(level)) + [option]
        self.expandedLevel = nil
        self.saveProgress()
        self.rebuild()
    }

    private func saveProgress() {
        guard self.messageId != 0 else { return }
        Self.progressByMessageId[self.messageId] = Progress(
            picked: self.picked,
            expandedLevel: self.expandedLevel
        )
    }

    private func retry() {
        guard let payload = self.payload else { return }
        self.loadState = .loading
        self.rebuild()
        self.loadCatalog(for: payload)
    }

    private func submit() {
        // Without the message id there is nowhere to record the submission, so the button
        // would stay live and every tap would send again. `isSubmitted` bails out on the
        // same condition, so the two have to agree.
        guard self.messageId != 0,
              self.isSubmitted == false,
              let catalog = self.catalog,
              let matched = catalog.matchingCase(for: self.picked) else { return }

        Self.submittedPickByMessageId[self.messageId] = self.picked
        self.expandedLevel = nil
        self.saveProgress()

        // The agent reads this text, so it carries the case id the guide lookup needs
        // plus the human-readable path the user picked.
        let lines = ["AS 자가조치 안내 요청", "접수 코드: \(matched.caseId)"]
            + zip(SampleASCatalog.levelLabels, self.picked).map { "\($0): \($1)" }

        self.rebuild()
        self.onSend?(lines.joined(separator: "\n"))
    }
}
#endif // INTERNAL_SAMPLE_CUSTOM_TEMPLATE
