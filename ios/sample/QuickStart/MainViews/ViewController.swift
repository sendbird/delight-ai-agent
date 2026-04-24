//
//  ViewController.swift
//  QuickStart
//

import UIKit
import SendbirdChatSDK
import SendbirdAIAgentMessenger

/// Main view controller demonstrating AIAgentStarterKit integration.
class ViewController: UIViewController {
    // MARK: - Views
    let gradientBackground = GradientBackgroundView()
    let logoImageView = UIImageView()
    let glassCardView = UIView()
    let tagLabel = UILabel()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let openMessengerButton = UIButton(type: .system)
    let toggleThemeButton = UIButton(type: .system)
    let loginOutButton = UIButton(type: .system)
    let secondaryButtonStack = UIStackView()
    let textContentStack = UIStackView()
    let versionLabel = UILabel()
    let footerLabel = UILabel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setupViews()
        self.setupLayouts()
        self.updateAllButtonStates()

        #if INTERNAL_TEST
        InternalTestManager.createAppInfoSettingButton(self)
        #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.attachLauncherIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AIAgentStarterKit.detachLauncher()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Actions
    @objc func onTapOpenMessenger() {
        AIAgentStarterKit.present(parent: self)
    }

    @objc func onTapToggleColorScheme() {
        AIAgentStarterKit.toggleColorScheme()
        self.updateThemeButtonTitle()
    }

    @objc func onTapLoginOut() {
        AIAgentStarterKit.isConnected ? self.logout() : self.login()
    }

    // MARK: - Authentication
    private func login() {
        self.updateSessionInfo()

        if ExtendedSDKBridge.hasUIKit() || ExtendedSDKBridge.hasDeskSDK() {
            AIAgentStarterKit.connect { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    debugPrint("[ViewController] Connect failed - \(error.localizedDescription)")
                    return
                }

                self.attachLauncherIfNeeded()
                self.updateAllButtonStates()
            }
        } else {
            AIAgentStarterKit.isConnected = true
            self.attachLauncherIfNeeded()
            self.updateAllButtonStates()
        }
    }

    private func logout() {
        AIAgentStarterKit.detachLauncher()

        AIAgentStarterKit.disconnect { [weak self] error in
            if let error = error {
                debugPrint("[ViewController] Disconnect failed - \(error.localizedDescription)")
            }
            self?.updateAllButtonStates()
        }
    }

    private func updateSessionInfo() {
        switch SampleConfiguration.sessionInfoType {
        case .manual:
            AIAgentStarterKit.updateSessionInfo(
                userId: SampleConfiguration.userId,
                sessionToken: SampleConfiguration.sessionToken,
                sessionHandler: AIAgentStarterKit.shared
            )
        case .anonymous:
            AIAgentStarterKit.updateAnonymousSessionInfo()
        }
    }

    // MARK: - UI Updates
    func updateAllButtonStates() {
        let isConnected = AIAgentStarterKit.isConnected
        self.openMessengerButton.isEnabled = isConnected
        self.openMessengerButton.alpha = isConnected ? 1.0 : 0.5
        self.toggleThemeButton.isEnabled = isConnected
        self.toggleThemeButton.alpha = isConnected ? 1.0 : 0.5
        self.loginOutButton.setTitle(
            isConnected ? Strings.logout : Strings.login,
            for: .normal
        )
        self.updateThemeButtonTitle()
    }

    private func updateThemeButtonTitle() {
        let title = AIAgentMessenger.currentColorScheme == .light
            ? Strings.lightThemeTitle
            : Strings.darkThemeTitle
        self.toggleThemeButton.setTitle(title, for: .normal)
    }

    // MARK: - Helpers
    private func attachLauncherIfNeeded() {
        guard AIAgentStarterKit.isConnected else { return }
        AIAgentStarterKit.attachLauncher(view: self.view)
    }
}
