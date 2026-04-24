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
    var window: UIWindow?

    // MARK: - Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let mainVC = ViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        #if INTERNAL_TEST
        setupInternalTest()
        #endif
        
        setupPushNotifications()
        initializeAIAgentSDK()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
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

        AIAgentStarterKit.initialize(
            applicationId: SampleConfiguration.appId,
            logLevel: SampleConfiguration.logLevel,
            completion: { error in
                if let error = error {
                    debugPrint("[AppDelegate] ❌ Initialization failed - \(error.localizedDescription)")
                }
                
                AIAgentStarterKit.updateContextObjects(language: "en", countryCode: "US", context: [:])
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
