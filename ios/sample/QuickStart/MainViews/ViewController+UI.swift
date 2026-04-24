//
//  ViewController+UI.swift
//  QuickStart
//

import UIKit

// MARK: - Design Tokens
enum Design {
    // Colors
    static let backgroundPrimary = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1.0)  // #0D0D0D
    static let accent = UIColor(red: 0.831, green: 0.902, blue: 0.271, alpha: 1.0)              // #D4E645
    static let accentOn = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1.0)            // #0D0D0D
    static let textPrimary = UIColor.white
    static let textSecondary = UIColor.white.withAlphaComponent(0.70)
    static let textTertiary = UIColor.white.withAlphaComponent(0.50)
    static let textMuted = UIColor.white.withAlphaComponent(0.31)
    static let cardBackground = UIColor.white.withAlphaComponent(0.05)
    static let cardBorder = UIColor.white.withAlphaComponent(0.08)

    // Sizing
    static let screenPadding: CGFloat = 24
    static let cardMargin: CGFloat = 20
    static let cardPaddingH: CGFloat = 24
    static let cardPaddingBottom: CGFloat = 24
    static let cardCornerRadius: CGFloat = 20
    static let primaryButtonHeight: CGFloat = 52
    static let secondaryButtonHeight: CGFloat = 44
    static let logoHeight: CGFloat = 24
    static let logoWidth: CGFloat = 100
    static let logoTopMargin: CGFloat = 20
    static let secondaryButtonGap: CGFloat = 12
    static let secondaryButtonTopMargin: CGFloat = 12
    static let footerBottomPadding: CGFloat = 16

    // Typography
    static let labelFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    static let titleFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let subtitleFont = UIFont.systemFont(ofSize: 14)
    static let primaryButtonFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let secondaryButtonFont = UIFont.systemFont(ofSize: 14)
    static let versionFont = UIFont.systemFont(ofSize: 11)
    static let footerFont = UIFont.systemFont(ofSize: 11)
}

// MARK: - Strings
enum Strings {
    static let label = "AI CONCIERGE"
    static let title = "Your branded\nAI concierge"
    static let subtitle = "An AI concierge you can trust to care for your customers through the entire lifecycle."
    static let openMessenger = "Open Messenger"
    static let lightThemeTitle = "Light"
    static let darkThemeTitle = "Dark"
    static let login = "Login"
    static let logout = "Log out"
    static let footer = "Powered by Delight.ai"
}

// MARK: - ViewController + UI Setup
extension ViewController {
    // MARK: - Setup Views
    func setupViews() {
        self.setupBackground()
        self.setupLogo()
        self.setupGlassCard()
        self.setupTextContent()
        self.setupButtons()
        self.setupFooter()
    }

    private func setupBackground() {
        self.gradientBackground.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.gradientBackground)
    }

    private func setupLogo() {
        self.logoImageView.image = UIImage(named: "logo_white")
        self.logoImageView.contentMode = .scaleAspectFit
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.logoImageView)
    }

    private func setupGlassCard() {
        self.glassCardView.backgroundColor = Design.cardBackground
        self.glassCardView.layer.borderColor = Design.cardBorder.cgColor
        self.glassCardView.layer.borderWidth = 1
        self.glassCardView.layer.cornerRadius = Design.cardCornerRadius
        self.glassCardView.clipsToBounds = true
        self.glassCardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.glassCardView)
    }

    private func setupTextContent() {
        // Tag label
        self.tagLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tagLabel.attributedText = NSAttributedString(
            string: Strings.label,
            attributes: [
                .kern: 1.8,
                .font: Design.labelFont,
                .foregroundColor: Design.accent
            ]
        )

        // Title label
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleParagraph = NSMutableParagraphStyle()
        titleParagraph.lineHeightMultiple = 1.1
        titleParagraph.alignment = .center
        self.titleLabel.attributedText = NSAttributedString(
            string: Strings.title,
            attributes: [
                .kern: -0.64,
                .font: Design.titleFont,
                .foregroundColor: Design.textPrimary,
                .paragraphStyle: titleParagraph
            ]
        )

        // Subtitle label
        self.subtitleLabel.numberOfLines = 0
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let subtitleParagraph = NSMutableParagraphStyle()
        subtitleParagraph.lineHeightMultiple = 1.5
        subtitleParagraph.alignment = .center
        self.subtitleLabel.attributedText = NSAttributedString(
            string: Strings.subtitle,
            attributes: [
                .font: Design.subtitleFont,
                .foregroundColor: Design.textSecondary,
                .paragraphStyle: subtitleParagraph
            ]
        )

        // Text stack
        self.textContentStack.axis = .vertical
        self.textContentStack.spacing = 12
        self.textContentStack.alignment = .center
        self.textContentStack.translatesAutoresizingMaskIntoConstraints = false
        self.textContentStack.addArrangedSubview(self.tagLabel)
        self.textContentStack.addArrangedSubview(self.titleLabel)
        self.textContentStack.addArrangedSubview(self.subtitleLabel)
        self.textContentStack.setCustomSpacing(16, after: self.tagLabel)
        self.glassCardView.addSubview(self.textContentStack)
    }

    private func setupButtons() {
        // Primary button
        self.openMessengerButton.setTitle(Strings.openMessenger, for: .normal)
        self.openMessengerButton.setTitleColor(Design.accentOn, for: .normal)
        self.openMessengerButton.titleLabel?.font = Design.primaryButtonFont
        self.openMessengerButton.backgroundColor = Design.accent
        self.openMessengerButton.layer.cornerRadius = Design.primaryButtonHeight / 2
        self.openMessengerButton.clipsToBounds = true
        self.openMessengerButton.translatesAutoresizingMaskIntoConstraints = false
        self.openMessengerButton.addTarget(self, action: #selector(self.onTapOpenMessenger), for: .touchUpInside)
        self.glassCardView.addSubview(self.openMessengerButton)

        // Secondary buttons
        for button in [self.toggleThemeButton, self.loginOutButton] {
            button.setTitleColor(Design.textPrimary, for: .normal)
            button.titleLabel?.font = Design.secondaryButtonFont
            button.backgroundColor = .clear
            button.layer.cornerRadius = Design.secondaryButtonHeight / 2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.white.cgColor
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        self.toggleThemeButton.addTarget(self, action: #selector(self.onTapToggleColorScheme), for: .touchUpInside)
        self.loginOutButton.addTarget(self, action: #selector(self.onTapLoginOut), for: .touchUpInside)

        // Secondary stack
        self.secondaryButtonStack.axis = .horizontal
        self.secondaryButtonStack.spacing = Design.secondaryButtonGap
        self.secondaryButtonStack.distribution = .fillEqually
        self.secondaryButtonStack.translatesAutoresizingMaskIntoConstraints = false
        self.secondaryButtonStack.addArrangedSubview(self.toggleThemeButton)
        self.secondaryButtonStack.addArrangedSubview(self.loginOutButton)
        self.glassCardView.addSubview(self.secondaryButtonStack)
    }

    private func setupFooter() {
        self.versionLabel.font = Design.versionFont
        self.versionLabel.textColor = Design.textTertiary
        self.versionLabel.textAlignment = .center
        self.versionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.versionLabel.text = self.versionString()
        self.view.addSubview(self.versionLabel)

        self.footerLabel.text = Strings.footer
        self.footerLabel.font = Design.footerFont
        self.footerLabel.textColor = Design.textMuted
        self.footerLabel.textAlignment = .center
        self.footerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.footerLabel)
    }

    // MARK: - Setup Layouts
    func setupLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // Gradient background
            self.gradientBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.gradientBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.gradientBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.gradientBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            // Logo (top-left)
            self.logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Design.logoTopMargin),
            self.logoImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Design.screenPadding),
            self.logoImageView.heightAnchor.constraint(equalToConstant: Design.logoHeight),
            self.logoImageView.widthAnchor.constraint(equalToConstant: Design.logoWidth),

            // Glass card
            self.glassCardView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
            self.glassCardView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Design.cardMargin),
            self.glassCardView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Design.cardMargin),
            self.glassCardView.bottomAnchor.constraint(equalTo: self.versionLabel.topAnchor, constant: -16),

            // Text content (centered vertically in space above buttons)
            self.textContentStack.leadingAnchor.constraint(equalTo: self.glassCardView.leadingAnchor, constant: Design.cardPaddingH),
            self.textContentStack.trailingAnchor.constraint(equalTo: self.glassCardView.trailingAnchor, constant: -Design.cardPaddingH),
            self.textContentStack.centerYAnchor.constraint(
                equalTo: self.glassCardView.centerYAnchor,
                constant: -(Design.primaryButtonHeight + Design.secondaryButtonTopMargin + Design.secondaryButtonHeight + Design.cardPaddingBottom) / 2
            ),

            // Open Messenger button
            self.openMessengerButton.leadingAnchor.constraint(equalTo: self.glassCardView.leadingAnchor, constant: Design.cardPaddingH),
            self.openMessengerButton.trailingAnchor.constraint(equalTo: self.glassCardView.trailingAnchor, constant: -Design.cardPaddingH),
            self.openMessengerButton.heightAnchor.constraint(equalToConstant: Design.primaryButtonHeight),
            self.openMessengerButton.bottomAnchor.constraint(equalTo: self.secondaryButtonStack.topAnchor, constant: -Design.secondaryButtonTopMargin),

            // Secondary button row
            self.secondaryButtonStack.leadingAnchor.constraint(equalTo: self.glassCardView.leadingAnchor, constant: Design.cardPaddingH),
            self.secondaryButtonStack.trailingAnchor.constraint(equalTo: self.glassCardView.trailingAnchor, constant: -Design.cardPaddingH),
            self.secondaryButtonStack.bottomAnchor.constraint(equalTo: self.glassCardView.bottomAnchor, constant: -Design.cardPaddingBottom),
            self.secondaryButtonStack.heightAnchor.constraint(equalToConstant: Design.secondaryButtonHeight),

            // Version label
            self.versionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Design.screenPadding),
            self.versionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Design.screenPadding),
            self.versionLabel.bottomAnchor.constraint(equalTo: self.footerLabel.topAnchor, constant: -4),

            // Footer
            self.footerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Design.screenPadding),
            self.footerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Design.screenPadding),
            self.footerLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Design.footerBottomPadding),
        ])
    }
}
