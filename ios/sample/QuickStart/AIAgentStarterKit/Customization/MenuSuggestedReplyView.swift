//
//  MenuSuggestedReplyView.swift
//  QuickStart
//
//  The reference implementation used in
//  `documents/customization/CustomizationGuide_SuggestedReplies.md`.
//  Kept identical to the guide snippet, so it uses plain UIKit constraints
//  instead of the SDK-internal `sba_constraint` helpers.
//

#if INTERNAL_SAMPLE_SUGGESTED_REPLY
import SendbirdAIAgentMessenger
import UIKit

final class MenuSuggestedReplyView: SBASuggestedReplyView {

    struct Constants {
        static let stackViewTop: CGFloat = 12
        static let stackViewSide: CGFloat = 12
        static let rowSpacing: CGFloat = 8
        static let rowCornerRadius: CGFloat = 16
        static let rowPaddingHorizontal: CGFloat = 20
        static let rowPaddingVertical: CGFloat = 16
        static let rowContentSpacing: CGFloat = 8
        static let chevronSize: CGFloat = 16
        static let titleFont: UIFont = .systemFont(ofSize: 15)
    }

    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.rowSpacing
        return stackView
    }()

    var rowViews: [UIView] = []

    // Runs on init with `options` still empty, and again on every configure.
    override func setupViews() {
        super.setupViews()

        if self.stackView.superview == nil {
            self.addSubview(self.stackView)
        }

        self.updateRowViews()
    }

    // Also re-runs on every configure, so activate each constraint only once.
    override func setupLayouts() {
        super.setupLayouts()

        // Child-to-parent constraints are owned by the parent, so the guard looks there.
        guard self.constraints.contains(where: { $0.firstItem === self.stackView }) == false else {
            return
        }

        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.stackViewSide
            ),
            self.stackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -Constants.stackViewSide
            ),
            self.stackView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Constants.stackViewTop
            ),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func updateRowViews() {
        self.rowViews.forEach { $0.removeFromSuperview() }
        self.rowViews = self.options.map { self.createRowView(with: $0) }
        self.rowViews.forEach { self.stackView.addArrangedSubview($0) }

        // The message cell fixes its VoiceOver element list and reads this for the replies part.
        // `nil` falls back to this view; an empty array would make the rows unreachable.
        self.accessibilityElements = self.rowViews.isEmpty ? nil : self.rowViews
    }

    private func createRowView(with option: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = option
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronView.tintColor = .tertiaryLabel
        chevronView.contentMode = .scaleAspectFit

        let contentView = UIStackView(arrangedSubviews: [titleLabel, chevronView])
        contentView.axis = .horizontal
        contentView.alignment = .center
        contentView.spacing = Constants.rowContentSpacing
        contentView.isUserInteractionEnabled = false

        let rowView = UIControl()
        rowView.accessibilityTraits = .button
        rowView.accessibilityLabel = option
        rowView.backgroundColor = .secondarySystemBackground
        rowView.layer.cornerRadius = Constants.rowCornerRadius
        // `selectOption(_:)` is the whole event path: the cell hides this view and the SDK
        // sends the option as a user message. No view controller code needed.
        rowView.addAction(
            UIAction { [weak self] _ in self?.selectOption(option) },
            for: .touchUpInside
        )

        rowView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        chevronView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(
                equalTo: rowView.leadingAnchor,
                constant: Constants.rowPaddingHorizontal
            ),
            contentView.trailingAnchor.constraint(
                equalTo: rowView.trailingAnchor,
                constant: -Constants.rowPaddingHorizontal
            ),
            contentView.topAnchor.constraint(
                equalTo: rowView.topAnchor,
                constant: Constants.rowPaddingVertical
            ),
            contentView.bottomAnchor.constraint(
                equalTo: rowView.bottomAnchor,
                constant: -Constants.rowPaddingVertical
            ),
            chevronView.widthAnchor.constraint(equalToConstant: Constants.chevronSize),
            chevronView.heightAnchor.constraint(equalToConstant: Constants.chevronSize)
        ])

        return rowView
    }
}
#endif // INTERNAL_SAMPLE_SUGGESTED_REPLY
