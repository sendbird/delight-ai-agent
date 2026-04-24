//
//  AIAgentTask.swift
//  QuickStart
//
//  Created by Tez Park on 6/23/25.
//

import UIKit
import SendbirdChatSDK
import SendbirdAIAgentMessenger

extension AIAgentStarterKit {
    /// Initializes the AIAgentMessenger.
    ///
    /// - Throws: An error if initialization fails.
    static func initialize(
        applicationId: String,
        logLevel: SBALogType,
        migrationHandler: VoidHandler? = nil
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AIAgentMessenger.initialize(
                appId: applicationId,
                paramsBuilder: { params in
                    params.logLevel = logLevel
                    params.migrationHandler = migrationHandler
                }
            ) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Updates the session information for the AIAgentMessenger.
    ///
    /// - Throws: An error if required session data is missing or invalid.
    static func updateManualSessionInfo() async throws {
        guard
            let userId = Self.sessionData.userId,
            let sessionToken = Self.sessionData.sessionToken,
            let sessionHandler = Self.sessionData.sessionHandler
        else {
            throw ChatError.invalidParameter.asSBError
        }
        
        AIAgentMessenger.updateSessionInfo(
            with: .manual(
                userId: userId,
                sessionToken: sessionToken,
                sessionDelegate: sessionHandler
            )
        )
    }
    
    static func updateAnonymousSessionInfo() async throws {
        AIAgentMessenger.updateSessionInfo(
            with: .anonymous()
        )
    }
    
    /// Connects the AIAgentMessenger.
    ///
    /// This function is currently not needed as connection is handled internally.
    static func connect() async throws {
        // There is no need to use this function because connect is handled internally when necessary.
        return try await withCheckedThrowingContinuation { continuation in
            AIAgentMessenger.authenticate(
                aiAgentId: SampleConfiguration.aiAgentId,
                paramsBuilder: { params in
                    params.context = self.contextObjects.context
                    params.countryCode = self.contextObjects.countryCode
                    params.language = self.contextObjects.language
                }
                
            ) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
    }
    
    /// Disconnects the AIAgentMessenger.
    ///
    /// - Throws: An error if disconnection fails.
    static func disconnect() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AIAgentMessenger.deauthenticate { continuation.resume() }
        }
    }
}
