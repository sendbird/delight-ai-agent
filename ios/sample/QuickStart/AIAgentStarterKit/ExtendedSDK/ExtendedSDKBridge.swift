//
//  ExtendedSDKBridge.swift
//  QuickStart
//
//  Created by Damon Park on 5/15/25.
//

/// This file defines the ExtendedSDKBridge which serves as a bridge for extended SDK functionalities,
/// providing singleton instances and task abstractions for integration guides.

import Foundation
import SendbirdChatSDK
import SendbirdAIAgentMessenger

/// Singleton class responsible for managing extended SDK integration-related tasks.
class ExtendedSDKBridge {
    static let instance = ExtendedSDKBridge()
}

// MARK: - COMMON
extension ExtendedSDKBridge {
    /// A closure type for handling errors.
    typealias ErrorHandler = (Error?) -> Void
}

// MARK: - ExtendedSDKBaseTaskable
/// Protocol defining the base requirements for extended SDK tasks,
/// abstracting common lifecycle state and initialization.
protocol ExtendedSDKBaseTaskable {
    var sessionData: AIAgentStarterKit.SessionData { get set }
    init(sessionData: AIAgentStarterKit.SessionData)
}

/// Protocol extending ExtendedSDKBaseTaskable to include asynchronous lifecycle methods
/// for initializing, connecting, and disconnecting SDK tasks.
protocol ExtendedSDKTaskable: ExtendedSDKBaseTaskable {
    func initialize(applicationId: String, logLevel: SBALogType, migrationHandler: VoidHandler?) async throws
    func connect() async throws
    func disconnect() async throws
}

// MARK: - Tasks
extension ExtendedSDKBridge {
    /// Base class providing a foundational implementation for extended SDK task workflows.
    class BaseTask: ExtendedSDKBaseTaskable {
        var sessionData: AIAgentStarterKit.SessionData
        required init(sessionData: AIAgentStarterKit.SessionData) { self.sessionData = sessionData }
    }
}
