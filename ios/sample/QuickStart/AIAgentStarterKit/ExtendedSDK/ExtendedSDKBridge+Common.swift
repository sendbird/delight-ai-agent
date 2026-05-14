//
//  ExtendedSDKBridge+Common.swift
//  QuickStart
//
//  Created by Tez Park on 6/17/25.
//

/// Orchestrates the lifecycle of extended SDKs (DeskSDK and UIKit).
///
/// This extension serves as a coordinator for managing SDK initialization, session updates,
/// connection, and disconnection in the correct order. It handles conditional execution
/// based on which SDKs are available in the project.
///
/// # SDK Initialization Order
/// The initialization sequence follows a specific order to ensure proper dependency management:
/// 1. **UIKit SDK** - UI components and chat functionality
/// 2. **DeskSDK** - Customer support desk features
/// 3. **AI Agent SDK** - AI-powered agent capabilities (handled separately)
///
///
import SendbirdAIAgentMessenger
import SendbirdChatSDK

extension ExtendedSDKBridge {

    // MARK: - Task Instances

    /// DeskSDK lifecycle task handler
    static var deskTask = ExtendedSDKBridge.DeskTask(sessionData: AIAgentStarterKit.sessionData)

    /// UIKit SDK lifecycle task handler
    static var uikitTask = ExtendedSDKBridge.SBUTask(sessionData: AIAgentStarterKit.sessionData)

    // MARK: - Lifecycle Orchestration

    /// Initializes all available extended SDKs in the correct order.
    ///
    /// This method should be called during app startup to prepare the SDKs for use.
    /// The initialization follows the order: UIKit → DeskSDK
    ///
    /// - Throws: An error if any SDK initialization fails
    static func initializeIfNeeded(
        applicationId: String,
        migrationHandler: VoidHandler? = nil
    ) async throws {
        // Phase 1: Initialize UIKit SDK
        if self.hasUIKit() {
            do {
                try await self.uikitTask.initialize(
                    applicationId: applicationId,
                    migrationHandler: migrationHandler
                )
            } catch {
                debugPrint("[ExtendedSDK] ❌ UIKit init failed - \(error.localizedDescription)")
                throw error
            }
        }

        // Phase 2: Initialize DeskSDK
        if self.hasDeskSDK() {
            do {
                try await self.deskTask.initialize(
                    applicationId: applicationId,
                    migrationHandler: migrationHandler
                )
            } catch {
                debugPrint("[ExtendedSDK] ❌ DeskSDK init failed - \(error.localizedDescription)")
                throw error
            }
        }
    }

    /// Updates session information for all available extended SDKs.
    ///
    /// This should be called when session data changes (e.g., user authentication updates)
    /// and needs to be propagated to the SDKs. The update follows the order: DeskSDK → UIKit
    ///
    /// - Throws: An error if any SDK session update fails
    static func updateSessionInfoIfNeeded() async throws {
        // Update DeskSDK session first
        if self.hasDeskSDK() {
            do {
                try await self.deskTask.updateSessionInfo()
            } catch {
                debugPrint("[ExtendedSDK] ❌ DeskSDK session update failed - \(error.localizedDescription)")
                throw error
            }
        }

        // Update UIKit session
        if self.hasUIKit() {
            do {
                try await self.uikitTask.updateSessionInfo()
            } catch {
                debugPrint("[ExtendedSDK] ❌ UIKit session update failed - \(error.localizedDescription)")
                throw error
            }
        }
    }

    /// Connects all available extended SDKs to their respective services.
    ///
    /// This establishes active communication channels with the SDK services.
    /// The connection follows the order: DeskSDK → UIKit
    ///
    /// - Throws: An error if any SDK connection fails
    static func connectIfNeeded() async throws {
        // Connect DeskSDK first
        if self.hasDeskSDK() {
            // If you are using DeskSDK, please uncomment the line below to enable DeskSDK connection.
//            do {
//                try await self.deskTask.connect()
//            } catch {
//                debugPrint("[ExtendedSDK] ❌ DeskSDK connect failed - \(error.localizedDescription)")
//                throw error
//            }
        }

        // Connect UIKit
        if self.hasUIKit() {
            do {
                try await self.uikitTask.connect()
            } catch {
                debugPrint("[ExtendedSDK] ❌ UIKit connect failed - \(error.localizedDescription)")
                throw error
            }
        }
    }

    /// Disconnects all available extended SDKs and releases their resources.
    ///
    /// This should be called during cleanup or app shutdown to properly release resources.
    /// The disconnection follows the order: DeskSDK → UIKit
    ///
    /// - Throws: An error if any SDK disconnection fails
    static func disconnectIfNeeded() async throws {
        // Disconnect DeskSDK first
        if self.hasDeskSDK() {
            do {
                try await self.deskTask.disconnect()
            } catch {
                debugPrint("[ExtendedSDK] ❌ DeskSDK disconnect failed - \(error.localizedDescription)")
                throw error
            }
        }

        // Disconnect UIKit
        if self.hasUIKit() {
            do {
                try await self.uikitTask.disconnect()
            } catch {
                debugPrint("[ExtendedSDK] ❌ UIKit disconnect failed - \(error.localizedDescription)")
                throw error
            }
        }
    }

    // MARK: - SDK Availability Checks

    /// Checks if DeskSDK is available in the project.
    ///
    /// - Returns: `true` if DeskSDK is linked and available, `false` otherwise
    static func hasDeskSDK() -> Bool {
        return SampleConfiguration.extendedSDKs.contains { $0 == .deskSDK }
    }

    /// Checks if UIKit SDK is available in the project.
    ///
    /// - Returns: `true` if UIKit SDK is linked and available, `false` otherwise
    static func hasUIKit() -> Bool {
        return SampleConfiguration.extendedSDKs.contains { $0 == .uiKit }
    }
}
