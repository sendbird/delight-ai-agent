//
//  AIAgentStarterKit+Context.swift
//  QuickStart
//
//  Created by Damon Park on 5/27/25.
//

import Foundation

// MARK: - Context Object Management

/// Extension providing context object management for AI Agent conversations.
///
/// Context objects allow you to provide additional information to AI agents,
/// such as user preferences, location, language settings, or custom metadata
/// that can enhance the conversation experience.
extension AIAgentStarterKit {

    /// A structure holding context information for AI Agent conversations.
    public struct ContextObjects {
        /// The user's preferred language code (e.g., "en", "ko", "ja")
        public var language: String?

        /// The user's country code (e.g., "US", "KR", "JP")
        public var countryCode: String?

        /// Additional custom context as key-value pairs
        public var context: [String: String] = [:]

        public init(
            language: String? = nil,
            countryCode: String? = nil,
            context: [String: String] = [:]
        ) {
            self.language = language
            self.countryCode = countryCode
            self.context = context
        }
    }

    /// The current context objects that will be sent with AI Agent requests.
    /// Left empty by default so the SDK falls back to the device locale; override via
    /// ``updateContextObjects(language:countryCode:context:)`` when an explicit value is needed.
    public static var contextObjects = ContextObjects()

    /// Updates the context objects for AI Agent conversations.
    ///
    /// Use this method to set or update contextual information that will be
    /// included in AI Agent requests. This can help provide personalized
    /// responses based on user preferences or location.
    ///
    /// - Parameters:
    ///   - language: Optional language code (e.g., "en", "ko")
    ///   - countryCode: Optional country code (e.g., "US", "KR")
    ///   - context: A dictionary of custom key-value pairs for additional context
    ///
    /// # Example Usage
    /// ```swift
    /// AIAgentStarterKit.updateContextObjects(
    ///     language: "en",
    ///     countryCode: "US",
    ///     context: [
    ///         "userTier": "premium",
    ///         "region": "west-coast"
    ///     ]
    /// )
    /// ```
    public static func updateContextObjects(
        language: String?,
        countryCode: String?,
        context: [String: String]
    ) {
        AIAgentStarterKit.contextObjects = .init(
            language: language,
            countryCode: countryCode,
            context: context
        )
    }

    /// Clears all context objects, resetting to default empty state.
    ///
    /// # Example Usage
    /// ```swift
    /// AIAgentStarterKit.clearContextObjects()
    /// ```
    public static func clearContextObjects() {
        AIAgentStarterKit.contextObjects = ContextObjects()
    }
}
