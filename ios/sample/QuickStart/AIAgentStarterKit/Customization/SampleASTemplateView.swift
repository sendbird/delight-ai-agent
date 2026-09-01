//
//  SampleASTemplateView.swift
//  QuickStart
//
//  Created by Tez Park on 8/31/26.
//
//  The one view the SDK knows about, and the router for the two sample templates.
//
//  `SBAConversationModule.List.Cell.CustomMessageTemplateView` is a single slot, so an
//  app that uses more than one custom template registers one class and dispatches on
//  the template id inside it. That is what this file does.
//
//  `as_selector_v1` carries the catalog address only; the card fetches the catalog and
//  narrows the pick down to one case id. `as_guide_v1` carries the guide for that case.
//
//  A message can carry several templates, so every entry is rendered in the order it
//  arrived rather than reading only the first one.
//

#if INTERNAL_SAMPLE_CUSTOM_TEMPLATE
import SendbirdAIAgentMessenger
import UIKit

final class SampleASTemplateView: SBACustomMessageTemplateView {

    // MARK: - Constants

    private enum Constants {
        static let cardSpacing: CGFloat = 8
        static let cardCornerRadius: CGFloat = 12
        static let cardInset: CGFloat = 16
        static let borderWidth: CGFloat = 1
    }

    // MARK: - Contract

    /// Template ids registered in the dashboard. These must match exactly.
    static let selectorTemplateId = "as_selector_v1"
    static let guideTemplateId = "as_guide_v1"

    // MARK: - Views

    private let containerView = UIView()
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.cardSpacing
        // Off before `addSubview`, or UIKit pins this to a zero frame and the card
        // collapses with no Auto Layout conflict logged.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var didInstallConstraints = false

    // MARK: - Layout

    /// Every card here is built from multi-line labels, which give up width before
    /// height. Without this the card narrows to its longest word.
    override var expandsToFullWidth: Bool { true }

    override func layoutBody() -> UIView? { self.containerView }

    override func setupViews() {
        super.setupViews()

        if self.cardStackView.superview == nil {
            self.containerView.addSubview(self.cardStackView)
        }
    }

    override func setupLayouts() {
        super.setupLayouts()

        // Not decided by looking at the parent's constraint list: UIKit's own
        // autoresizing constraints live there too and would make any such check pass.
        guard self.didInstallConstraints == false else { return }
        self.didInstallConstraints = true

        NSLayoutConstraint.activate([
            self.cardStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.cardStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.cardStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.cardStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])

    }

    // MARK: - Configuration

    override func configure(with customMessageTemplates: [SBACustomMessageTemplateData]?) {
        // Installs the body and re-runs the setup methods.
        super.configure(with: customMessageTemplates)

        self.buildCards(from: customMessageTemplates)
    }

    private func buildCards(from templates: [SBACustomMessageTemplateData]?) {
        self.cardStackView.arrangedSubviews.forEach {
            self.cardStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for template in templates ?? [] {
            guard let card = self.makeCard(for: template) else { continue }
            self.cardStackView.addArrangedSubview(card)
        }

        // The cards report their own height changes, so this only covers the case where
        // none of them did. Asking on every reconfigure invalidates the item layout far
        // more often than the content changes, which is visible while a message streams.
        if self.cardStackView.arrangedSubviews.isEmpty {
            self.cardStackView.addArrangedSubview(self.makeFallbackCard())
            self.invalidateContentSize()
        }
    }

    /// Builds the card for one template entry, or `nil` when the id is unknown or the
    /// JSON does not parse.
    private func makeCard(for template: SBACustomMessageTemplateData) -> UIView? {
        switch template.templateId {
        case Self.selectorTemplateId:
            let card = SampleASSelectorCardView()
            // Lets the card keep the user's picks when the cell is rebuilt on scroll.
            card.messageId = self.messageId
            // Wired before `configure`, which draws the card and reports its height.
            // Setting these after would drop that first report.
            // Send goes through the SDK, so the pending row, the input lock while the
            // agent replies, and the send-failure handling all apply.
            card.onSend = { [weak self] text in self?.sendUserMessage(text) }
            card.onHeightChange = { [weak self] in self?.invalidateContentSize() }
            guard card.configure(withContent: template.response.content) else { return nil }
            return card

        case Self.guideTemplateId:
            let card = SampleASGuideCardView()
            card.onSend = { [weak self] text in self?.sendUserMessage(text) }
            card.onHeightChange = { [weak self] in self?.invalidateContentSize() }
            guard card.configure(withContent: template.response.content) else { return nil }
            return card

        default:
            return nil
        }
    }

    /// Shown when no entry matched. iOS renders nothing at all when a custom template
    /// produces no content, and the message body of a template message is empty, so an
    /// unknown id would otherwise reach the user as a blank turn.
    private func makeFallbackCard() -> UIView {
        let label = UILabel()
        label.text = "지금은 이 안내를 표시할 수 없어요. 상담원 연결을 원하시면 말씀해 주세요."
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = Constants.cardCornerRadius
        container.layer.borderWidth = Constants.borderWidth
        container.layer.borderColor = UIColor.separator.cgColor
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.cardInset),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.cardInset),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.cardInset),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.cardInset)
        ])
        return container
    }
}

#endif // INTERNAL_SAMPLE_CUSTOM_TEMPLATE
