//
//  DeskTask.swift
//  QuickStart
//
//  Created by Tez Park on 6/16/25.
//

/// This file defines the `DeskTask` class which manages DeskSDK-specific lifecycle for the extended SDK bridge.

import SendbirdAIAgentMessenger
import Foundation
import SendbirdChatSDK
#if canImport(SendBirdDesk)
import SendBirdDesk
#endif

extension ExtendedSDKBridge {
    /// A DeskSDK-specific implementation of `ExtendedSDKTaskable` that handles initialization,
    /// connection, session updates, and disconnection for the DeskSDK within the extended SDK bridge.
    class DeskTask: BaseTask, ExtendedSDKTaskable {
        /// Initializes the SendbirdChat and DeskSDK components asynchronously.
        /// Throws an error if initialization fails.
        func initialize(
            applicationId: String,
            migrationHandler: VoidHandler? = nil
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                #if canImport(SendBirdDesk)
                let initializeDeskBlock: (() -> Void) = {
                    if SBDSKMain.initializeDesk() == false {
                        continuation.resume(
                            throwing: ChatError.invalidParameter.asSBError
                        )
                        return
                    }
                }
                
                if SendbirdChat.isInitialized {
                    initializeDeskBlock()
                    continuation.resume()
                    return
                }

                let params = InitParams(
                    applicationId: applicationId,
                    isLocalCachingEnabled: true
                )
                
                // NOTE: SendbirdDesk must be initialized and used with SendbirdChat.
                SendbirdChat.initialize(
                    params: params,
                    migrationStartHandler: migrationHandler,
                    completionHandler: { error in
                        if let error {
                            continuation.resume(throwing: error)
                            return
                        }
                        initializeDeskBlock()
                        continuation.resume()
                    }
                )
                #else
                continuation.resume()
                #endif
            }
        }
        
        /// Updates session information if needed.
        /// This implementation does nothing as no session update is required.
        func updateSessionInfo() async throws {
            // do nothing
        }
        
        /// Connects to the DeskSDK using the current user's ID and session token.
        /// Throws an error if the user ID is missing or authentication fails.
        func connect() async throws {
            guard let userId = AIAgentStarterKit.sessionData.userId else {
                throw ChatError.invalidParameter.asSBError
            }

            let sessionToken = AIAgentStarterKit.sessionData.sessionToken

            #if canImport(SendBirdDesk)
            try await ExtendedSDKBridge.asyncify { completion in
                SendbirdChat.connect(
                    userId: userId,
                    authToken: sessionToken
                ) { user, error in
                    SBDSKMain.authenticate(
                        withUserId: userId,
                        accessToken: sessionToken
                    ) { error in
                        completion(error)
                    }
                }
            }
            #endif
        }
        
        /// Disconnects from the DeskSDK.
        /// This implementation calls `initializeDesk` as part of the disconnection process.
        func disconnect() async throws {
            #if canImport(SendBirdDesk)
            SBDSKMain.initializeDesk()
            #endif
        }
    }
}
