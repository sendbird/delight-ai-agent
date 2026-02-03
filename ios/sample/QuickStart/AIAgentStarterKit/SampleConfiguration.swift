//
//  SampleConfiguration.swift
//  QuickStart
//
//  Created by Tez Park on 6/18/25.
//

import Foundation
import SendbirdAIAgentMessenger
#if canImport(SendBirdDesk)
import SendBirdDesk
#endif
#if canImport(SendbirdUIKit)
import SendbirdUIKit
#endif

/// Provides sample configuration data for testing Delight AI Agent SDK.
/// This configuration is designed for QuickStart sample apps and can be customized as needed.
struct SampleConfiguration {

    // MARK: - Types

    /// Represents the supported Sendbird SDKs integrated in the project.
    enum ExtendedSDKType {
        /// SendbirdUIKit integration
        case uiKit
        /// SendBirdDesk SDK integration
        case deskSDK
    }

    /// Session authentication type for the AI Agent SDK.
    enum SessionInfoType {
        case manual
        case anonymous
    }

    // MARK: - Session Configuration

    /// The session authentication type to use.
    /// - `.manual`: Requires userId and sessionToken
    /// - `.anonymous`: Automatic anonymous user creation
    static var sessionInfoType: SessionInfoType = .manual

    // MARK: - Sendbird Server Configuration

    /// Optional production server URL for Sendbird services.
    /// Set to `nil` to use the default Sendbird server.
    static var productionServer: String? = nil

    // MARK: - Application Configuration

    /// Your Sendbird application ID.
    /// Get this from your Sendbird Dashboard: https://dashboard.sendbird.com
    static var appId = "10306808-B7F3-436F-9F5C-29F431B47B73"

    /// The AI agent ID to use for AI-driven conversations.
    /// Create and manage AI agents in your Sendbird Dashboard.
    static var aiAgentId = "e4c57465-4773-432e-9740-f0284a951494"

    // MARK: - User Authentication

    /// The user ID for manual session mode.
    /// This should be obtained from your service server API.
    static var userId = "client_user"

    /// The session token paired with the user ID.
    /// This should be obtained from your service server API when using manual session mode.
    static var sessionToken = "deb776838a0dca710fffd9c38b06ed133e2d088f"
    
    /// The log level for Delight AI Agent Messenger SDK.
    /// This controls the verbosity of logs output by the SDK.
    #if INTERNAL_TEST
    static var logLevel: SBALogType = .none
    #else
    static var logLevel: SBALogType = .error
    #endif

    // MARK: - Extended SDK Integration

    /// Returns the list of integrated extended SDKs based on the current imports.
    /// This is automatically detected based on which SDKs are linked to your project.
    ///
    /// - Note: This property is automatically managed. Do not modify manually.
    /// - Returns: An array of `ExtendedSDKType` representing available SDKs
    static var extendedSDKs: [ExtendedSDKType] {
        var sdkTypes: [ExtendedSDKType] = []
        #if canImport(SendBirdDesk)
        sdkTypes.append(.deskSDK)
        #endif
        #if canImport(SendbirdUIKit)
        sdkTypes.append(.uiKit)
        #endif
        return sdkTypes
    }

    // MARK: - Helper Methods

    /// Checks if SendbirdUIKit is integrated.
    static var hasUIKit: Bool {
        extendedSDKs.contains(.uiKit)
    }

    /// Checks if SendBirdDesk SDK is integrated.
    static var hasDeskSDK: Bool {
        extendedSDKs.contains(.deskSDK)
    }
}
