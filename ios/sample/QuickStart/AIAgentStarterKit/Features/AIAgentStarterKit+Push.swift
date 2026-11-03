//
//  AIAgentStarterKit+Push.swift
//  QuickStart
//
//  Created by Damon Park on 5/27/25.
//

import UIKit
import SendbirdAIAgentMessenger
import SendbirdChatSDK

// MARK: - Push Notification Handling

/// Extension providing push notification management capabilities.
///
/// This extension handles:
/// - Push token registration/unregistration
/// - Push notification click tracking
/// - Deep linking from push notifications to conversations
/// - Sendbird push notification validation
extension AIAgentStarterKit {

    /// Temporarily stores a push notification payload for deferred handling.
    ///
    /// This is used when a push notification is received but the app is not yet
    /// ready to present the conversation screen (e.g., during app launch).
    public static var pendingNotificationPayload: [AnyHashable: Any]?

    // MARK: - Push Token Management

    /// Registers the device token for push notifications with Delight AI Agent Messenger.
    ///
    /// This method should be called in your AppDelegate's
    /// `didRegisterForRemoteNotificationsWithDeviceToken` method after receiving
    /// a device token from APNs.
    ///
    /// - Parameter deviceToken: The device token data received from APNs
    ///
    /// # Example Usage in AppDelegate
    /// ```swift
    /// func application(
    ///     _ application: UIApplication,
    ///     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    /// ) {
    ///     AIAgentStarterKit.registerPush(deviceToken: deviceToken)
    /// }
    /// ```
    public static func registerPush(deviceToken: Data) {
        AIAgentMessenger.registerPush(
            deviceToken: deviceToken
        ) { success in
            if !success {
                debugPrint("[Push] ❌ Failed to register APNs device token")
            }
        }
    }

    /// Unregisters the device token for push notifications from Delight AI Agent Messenger.
    ///
    /// Call this method when:
    /// - User logs out
    /// - User disables push notifications in settings
    /// - App no longer wants to receive push notifications
    ///
    /// # Example Usage
    /// ```swift
    /// // During logout
    /// AIAgentStarterKit.unregisterPush()
    /// AIAgentStarterKit.disconnect()
    /// ```
    public static func unregisterPush() {
        AIAgentMessenger.unregisterPushToken { success in
            if !success {
                debugPrint("[Push] ❌ Failed to unregister APNs token")
            }
        }
    }

    // MARK: - Push Notification Click Tracking

    /// Marks a Sendbird push notification as clicked.
    ///
    /// This method informs Sendbird Chat SDK that the user has interacted with
    /// a push notification. It should be called when handling push notification taps.
    ///
    /// - Parameter userInfo: The payload dictionary received from the push notification
    ///
    /// # Example Usage
    /// ```swift
    /// func userNotificationCenter(
    ///     _ center: UNUserNotificationCenter,
    ///     didReceive response: UNNotificationResponse
    /// ) {
    ///     let userInfo = response.notification.request.content.userInfo
    ///     AIAgentStarterKit.markPushNotificationAsClicked(userInfo: userInfo)
    /// }
    /// ```
    public static func markPushNotificationAsClicked(userInfo: [AnyHashable: Any]) {
        SendbirdChat.markPushNotificationAsClicked(
            remoteNotificationPayload: userInfo
        )
    }

    // MARK: - Deep Linking from Push Notifications

    /// Presents the conversation screen triggered by a push notification.
    ///
    /// This method:
    /// 1. Validates that the notification is from Sendbird
    /// 2. Stores the notification payload for handling
    /// 3. Finds the appropriate view controller to present on
    /// 4. Connects to chat and presents the conversation
    ///
    /// - Parameters:
    ///   - userInfo: The notification payload dictionary
    ///   - topViewController: Optional view controller to present from.
    ///     If `nil`, the method will automatically find the topmost view controller.
    ///
    /// # Example Usage
    /// ```swift
    /// func userNotificationCenter(
    ///     _ center: UNUserNotificationCenter,
    ///     didReceive response: UNNotificationResponse,
    ///     withCompletionHandler completionHandler: @escaping () -> Void
    /// ) {
    ///     let userInfo = response.notification.request.content.userInfo
    ///
    ///     AIAgentStarterKit.presentFromNotification(
    ///         userInfo: userInfo,
    ///         topViewController: nil  // Auto-detect
    ///     )
    ///
    ///     completionHandler()
    /// }
    /// ```
    public static func presentFromNotification(
        userInfo: [AnyHashable: Any]?,
        topViewController: UIViewController?
    ) {
        guard AIAgentStarterKit.isValidSendbirdPush(userInfo: userInfo) else { return }

        AIAgentStarterKit.pendingNotificationPayload = userInfo

        // Use provided view controller if available
        if let topViewController = topViewController {
            AIAgentStarterKit.handlePendingPush(parent: topViewController)
            return
        }

        // Auto-detect the topmost view controller
        // `connectedScenes` is an unordered set, so look at the foreground-active scene first.
        let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let orderedScenes = windowScenes.filter { $0.activationState == .foregroundActive }
            + windowScenes.filter { $0.activationState != .foregroundActive }
        let keyWindow = orderedScenes.lazy
            .compactMap { windowScene in windowScene.windows.first(where: { $0.isKeyWindow }) }
            .first

        if let rootViewController = keyWindow?.rootViewController {

            var topController = rootViewController
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }

            // Handle navigation controller case
            if let nav = topController as? UINavigationController,
               let viewController = nav.viewControllers.last as? ViewController {
                AIAgentStarterKit.handlePendingPush(parent: viewController)
            } else {
                AIAgentStarterKit.handlePendingPush(parent: topController)
            }
        }
    }

    /// Handles any pending push notification by connecting and presenting the conversation.
    ///
    /// This method is called internally by `presentFromNotification` and can also be
    /// called manually if you want to defer push notification handling.
    ///
    /// - Parameter parent: The view controller on which to present the conversation
    ///
    /// # Example Usage
    /// ```swift
    /// // Manually handle a pending push after user completes onboarding
    /// if let viewController = self.navigationController?.topViewController {
    ///     AIAgentStarterKit.handlePendingPush(parent: viewController)
    /// }
    /// ```
    public static func handlePendingPush(parent: UIViewController) {
        guard AIAgentStarterKit.pendingNotificationPayload != nil else { return }

        self.connect { _ in
            AIAgentStarterKit.pendingNotificationPayload = nil
            AIAgentStarterKit.present(parent: parent)
        }
    }

    // MARK: - Push Notification Validation

    /// Validates whether the given userInfo dictionary is a Sendbird push notification.
    ///
    /// - Parameter userInfo: The notification payload dictionary
    /// - Returns: `true` if the payload contains Sendbird-specific keys; otherwise `false`
    ///
    /// # Example Usage
    /// ```swift
    /// if AIAgentStarterKit.isValidSendbirdPush(userInfo: userInfo) {
    ///     // Handle Sendbird push
    ///     AIAgentStarterKit.presentFromNotification(userInfo: userInfo, topViewController: nil)
    /// } else {
    ///     // Handle other app-specific notifications
    /// }
    /// ```
    public static func isValidSendbirdPush(userInfo: [AnyHashable: Any]?) -> Bool {
        guard let _ = userInfo?["sendbird"] as? [AnyHashable: Any] else {
            return false
        }
        return true
    }
}
