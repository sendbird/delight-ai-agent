//
//  AIAgentStarterKit.swift
//  QuickStart
//
//  Created by Tez Park on 5/12/25.
//

import UIKit
import SendbirdAIAgentMessenger
import SendbirdChatSDK

// MARK: - AIAgentStarterKit

/// A simplified starter kit for integrating Delight AI Agent SDK into your iOS application.
///
/// `AIAgentStarterKit` provides a convenient wrapper around the Delight AI Agent SDK,
/// handling initialization, session management, connection, and UI presentation.
/// It's designed for QuickStart samples and can be customized for production use.
///
/// # Key Features
/// - Easy SDK initialization with minimal configuration
/// - Session management (manual and anonymous modes)
/// - Automatic token refresh handling
/// - UI presentation helpers (full-screen and launcher button)
/// - Extended SDK integration (UIKit, DeskSDK)
/// - Theme, context, and push notification support
///
/// # Usage
/// See individual method documentation for detailed usage examples.
/// Configuration properties are defined in `AIAgentStarterKit+Configuration.swift`.
///
class AIAgentStarterKit: NSObject { }

// MARK: - Initialize
extension AIAgentStarterKit {
    /// Initializes the AI Agent SDK with the given application ID.
    /// - Parameters:
    ///   - appId: The application ID to initialize the SDK.
    ///   - completion: Optional completion handler called with an error if initialization fails.
    static func initialize(
        applicationId: String,
        logLevel: SBALogType = .none,
        startHandler: VoidHandler? = nil,
        migrationHandler: VoidHandler? = nil,
        completion: ErrorHandler? = nil
    ) {
        Self.sessionData.appId = applicationId
        
        Task {
            do {
                // Call the start handler before initialization
                startHandler?()

                // Step 1: Extended SDK initialization
                // initialize priority: UIKit, Desk, AIAgent
                // INFO: This is only necessary when using extended SDKs(e,g,. UIKit, DeskSDK).
                try await ExtendedSDKBridge.initializeIfNeeded(
                    applicationId: applicationId,
                    logLevel: logLevel,
                    migrationHandler: migrationHandler
                )

                // Step 2: AI Agent SDK initialization
                try await self.initialize(
                    applicationId: applicationId,
                    logLevel: logLevel,
                    migrationHandler: migrationHandler
                )

                AIAgentStarterKit.status = .initialized

                #if INTERNAL_TEST
                InternalTestManager.updateHost(SampleConfiguration.productionServer)
                #endif

                Thread.executeOnMain {
                    completion?(nil)
                }
            } catch {
                debugPrint("[Initialize] ❌ Failed - \(error.localizedDescription)")
                Thread.executeOnMain {
                    completion?(error)
                }
            }
        }
    }
}

// MARK: - Session Management
extension AIAgentStarterKit {
    /// Updates the current session information with user ID, session token, and session handler.
    /// - Parameters:
    ///   - userId: The user ID for the session.
    ///   - sessionToken: The session token for authentication.
    ///   - sessionHandler: The delegate to handle session events.
    static func updateSessionInfo(
        userId: String,
        sessionToken: String?,
        sessionHandler: SessionDelegate?
    ) {
        // Set the session data.
        AIAgentStarterKit.sessionData.userId = userId
        AIAgentStarterKit.sessionData.sessionToken = sessionToken
        AIAgentStarterKit.sessionData.sessionHandler = sessionHandler
        
        Task {
            do {
                // Step 1: Extended SDK session info update
                // INFO: This is only necessary when using extended SDKs(e,g,. UIKit, DeskSDK).
                try await ExtendedSDKBridge.updateSessionInfoIfNeeded()

                // Step 2: AI Agent session info update
                try await self.updateManualSessionInfo()

                AIAgentStarterKit.status = .readyToUse
            } catch {
                debugPrint("[Session] ❌ Update failed - \(error.localizedDescription)")
            }
        }
    }
    
    static func updateAnonymousSessionInfo(
    ) {
        Task {
            do {
                try await self.updateAnonymousSessionInfo()

                AIAgentStarterKit.status = .readyToUse
            } catch {
                debugPrint("[Session] ❌ Anonymous session update failed - \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Connect/Disconnect
extension AIAgentStarterKit {
    /// Connects to the AI Agent service.
    /// - Parameter completion: Optional completion handler called with an error if connection fails.
    static func connect(completion: ErrorHandler? = nil) {
        Task {
            do {
                self.isConnected = true

                // Connection priority: AIAgent, UIKit
                
                // Note: If you only use AIAgent, there is no need to use this function because connect is handled internally when necessary.
                try await self.connect()

                // INFO: This is only necessary when using extended SDKs(e,g,. UIKit, DeskSDK).
                try await ExtendedSDKBridge.connectIfNeeded()

                Thread.executeOnMain {
                    completion?(nil)
                }
            } catch {
                debugPrint("[Connect] ❌ Failed - \(error.localizedDescription)")
                Thread.executeOnMain {
                    completion?(error)
                }
            }
        }
    }
    
    /// Disconnects from the AI Agent service.
    /// - Parameter completion: Optional completion handler called with an error if disconnection fails.
    static func disconnect(completion: ErrorHandler? = nil) {
        Task {
            do {
                self.isConnected = false

                // INFO: This is only necessary when using extended SDKs(e,g,. UIKit, DeskSDK).
                try await ExtendedSDKBridge.disconnectIfNeeded()

                try await self.disconnect()

                Thread.executeOnMain {
                    completion?(nil)
                }
            } catch {
                debugPrint("[Disconnect] ❌ Failed - \(error.localizedDescription)")
                Thread.executeOnMain {
                    completion?(error)
                }
            }
        }
    }
}

// MARK: - Present Conversation & Attach Launcher
extension AIAgentStarterKit {
    /// Use this when you want to display in full screen.
    /// - Parameter parent: The ViewController to parent and integrate with.
    static func present(parent: UIViewController) {
        AIAgentStarterKit.applyCustomizations()

        AIAgentMessenger.presentConversation(
            aiAgentId: SampleConfiguration.aiAgentId
        ) { params in
            params.language = self.contextObjects.language
            params.countryCode = self.contextObjects.countryCode
            params.context = self.contextObjects.context
            params.parent = parent
        }

        // - NOTE: Use this logic if you want to present it as a conversation list.
//        AIAgentMessenger.presentConversationList(
//            aiAgentId: SampleConfiguration.aiAgentId
//        ) { params in
//            params.language = self.contextObjects.language
//            params.countryCode = self.contextObjects.countryCode
//            params.context = self.contextObjects.context
//            params.parent = parent
//        }
}
    
    /// Use this when you want to show and use the launcher button from the Delight AI Dashboard.
    /// - Parameter view: The view to parent.
    static func attachLauncher(view: UIView? = nil) {
        AIAgentStarterKit.applyCustomizations()

        let options = AIAgentStarterKit.defaultLauncherOptions
        
        // INFO: Sample
//      options = SBALauncherOptions(
//            parentView: nil, // the view that will be the launcher's parent view, if not, attach to window.
//            entryPoint: .conversationList,
//
//            // options to set the layout of the laucnher button
//            layout: .init(
//                position: .trailingTop,
//                margin: .default,
//                useSafeArea: true
//            ),
//
//            // Options to set how the conversation screen is displayed
//            displayStyle: .fullscreen(
//                .init(
//                    presentationStyle: .fullScreen,
//                    parentController: nil
//                )
//            )
//        )
        
        // The point at which the context object is assigned is when the launcher is exposed.
        let startLauncher: (() -> Void) = {
            AIAgentMessenger.attachLauncher(
                aiAgentId: SampleConfiguration.aiAgentId
            ) { params in
                params.language = self.contextObjects.language
                params.countryCode = self.contextObjects.countryCode
                params.context = self.contextObjects.context
                params.options = options
            }
        }

        AIAgentStarterKit.onReadyToUse = startLauncher

        startLauncher()
    }

    /// Call this if you attach a launcher to the window.
    static func detachLauncher() {
        AIAgentMessenger.detachLauncher(
            aiAgentId: SampleConfiguration.aiAgentId
        )
    }
}
