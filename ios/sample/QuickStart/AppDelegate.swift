//
//  AppDelegate.swift
//  QuickStart
//

import UIKit
import SendbirdChatSDK
import SendbirdAIAgentMessenger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    #if INTERNAL_TEST
    private var mockTestHost: AIAgentMockTestHost?
    #endif

    // MARK: - Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        #if INTERNAL_TEST
        setupInternalTest()
        if prepareMockTestHostIfNeeded() {
            return true
        }
        #endif

        setupPushNotifications()
        initializeAIAgentSDK()

        return true
    }

    // MARK: - Setup
    private func setupInternalTest() {
        #if INTERNAL_TEST
        InternalTestManager.loadTestAppInfo()
        if !InternalTestManager.isRunningTests {
            InternalTestManager.restoreQueryParams()
        }
        #endif
    }

    #if INTERNAL_TEST
    /// The window arrives later from `SceneDelegate`, which installs the host via `configure(window:)`.
    private func prepareMockTestHostIfNeeded() -> Bool {
        do {
            guard let configuration = try AIAgentMockLaunchConfiguration.load() else {
                return false
            }

            self.mockTestHost = AIAgentMockTestHost(configuration: configuration)
            return true
        } catch {
            fatalError("[AppDelegate] Invalid AI Agent mock launch configuration: \(error.localizedDescription)")
        }
    }
    #endif

    private func setupPushNotifications() {
        // Note: This may trigger 800100 error during initialization
        // The error is expected and harmless - device token will be stored
        // and registered after connection is established
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert]) { granted, error in
            Thread.executeOnMain {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func initializeAIAgentSDK() {
        #if INTERNAL_TEST
        guard !InternalTestManager.isRunningTests else { return }
        #endif

        SendbirdLogger.setLevel(SampleConfiguration.logLevel)

        AIAgentStarterKit.initialize(
            applicationId: SampleConfiguration.appId,
            completion: { error in
                if let error = error {
                    debugPrint("[AppDelegate] ❌ Initialization failed - \(error.localizedDescription)")
                }
            }
        )
    }

    // MARK: - Push Notification Registration
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        AIAgentStarterKit.registerPush(deviceToken: deviceToken)
    }
}

// MARK: - SceneWindowConfiguring
extension AppDelegate: SceneWindowConfiguring {
    func configure(window: UIWindow) {
        #if INTERNAL_TEST
        if let mockTestHost = self.mockTestHost {
            mockTestHost.install(on: window)
            return
        }
        #endif

        let mainVC = ViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notifications when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Uncomment to show notifications while app is in foreground
        // completionHandler([.alert, .badge, .sound])
        completionHandler([])
    }

    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        guard AIAgentStarterKit.isValidSendbirdPush(userInfo: userInfo) else {
            completionHandler()
            return
        }

        AIAgentStarterKit.presentFromNotification(
            userInfo: userInfo,
            topViewController: nil
        )

        completionHandler()
    }
}
