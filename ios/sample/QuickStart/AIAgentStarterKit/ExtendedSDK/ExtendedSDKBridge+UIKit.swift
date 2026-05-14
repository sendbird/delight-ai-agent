//
//  SBUTask.swift
//  QuickStart
//
//  Created by Tez Park on 6/16/25.
//

/// UIKit-specific task manager for Sendbird extended SDK lifecycle management.
import SendbirdAIAgentMessenger
import Foundation
import SendbirdChatSDK
#if canImport(SendbirdUIKit)
import SendbirdUIKit
#endif

extension ExtendedSDKBridge {
    /// UIKit extension of `ExtendedSDKTaskable` that manages initialization, session updates, connection, and disconnection tasks.
    class SBUTask: BaseTask, ExtendedSDKTaskable {
        /// Initializes the Sendbird UIKit SDK with the provided application ID and initialization parameters.
        /// This method must be called before performing any other SDK operations.
        /// - Throws: An error if initialization fails.
        /// - Note: This method only performs actions if SendbirdUIKit is available.
        func initialize(
            applicationId: String,
            migrationHandler: VoidHandler? = nil
        ) async throws {
            #if canImport(SendbirdUIKit)
            if SendbirdChat.isInitialized {
                return
            }

            try await ExtendedSDKBridge.asyncify { completion in
                SendbirdUIKit.SendbirdUI.initialize(
                    applicationId: applicationId,
                    migrationHandler: {
                        migrationHandler?()
                    }, completionHandler: { error in
                        completion(error)
                    }
                )
            }
            #endif
        }
        
        /// Updates the current session information such as user ID and access token in the UIKit globals.
        /// - Throws: An error if the user ID is not available.
        /// - Note: This method only performs actions if SendbirdUIKit is available.
        func updateSessionInfo() async throws {
            guard let userId = AIAgentStarterKit.sessionData.userId else {
                throw ChatError.invalidParameter.asSBError
            }
            #if canImport(SendbirdUIKit)
            SendbirdUIKit.SBUGlobals.currentUser = SBUUser(userId: userId)
            SendbirdUIKit.SBUGlobals.accessToken = AIAgentStarterKit.sessionData.sessionToken
            #endif
        }
        
        /// Connects to the Sendbird UIKit service asynchronously.
        /// - Throws: An error if the connection fails.
        /// - Note: This method only performs actions if SendbirdUIKit is available.
        func connect() async throws {
            #if canImport(SendbirdUIKit)
            try await ExtendedSDKBridge.asyncify { completion in
                SendbirdUI.connect { user, error in
                    completion(error)
                }
            }
            #endif
        }
        
        /// Disconnects from the Sendbird UIKit service asynchronously.
        /// - Note: This method only performs actions if SendbirdUIKit is available.
        func disconnect() async throws {
            #if canImport(SendbirdUIKit)
            try await ExtendedSDKBridge.asyncify { completion in
                SendbirdUI.disconnect { completion(nil) }
            }
            #endif
        }
    }
}
