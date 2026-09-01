//
//  AIAgentMockLaunchConfiguration.swift
//  QuickStart
//

import Foundation

struct AIAgentMockLaunchConfiguration {
    enum RunMode: String {
        case playback
        case record
    }

    enum ConfigurationError: LocalizedError {
        case unsupportedRunMode(String)
        case missingValue(String)
        case invalidURL(key: String, value: String)
        case unsupportedURLScheme(key: String, value: String, expectedSchemes: [String])

        var errorDescription: String? {
            switch self {
            case .unsupportedRunMode(let mode):
                return "Unsupported AI Agent UI test run mode: \(mode)"
            case .missingValue(let key):
                return "Missing AI Agent UI test environment value: \(key)"
            case .invalidURL(let key, let value):
                return "Invalid AI Agent UI test URL for \(key): \(value)"
            case .unsupportedURLScheme(let key, let value, let expectedSchemes):
                return "Unsupported AI Agent UI test URL scheme for \(key): \(value). Expected one of: \(expectedSchemes.joined(separator: ", "))"
            }
        }
    }

    static let runModeKey = "SBA_AIAGENT_RUN_MODE"
    static let appIdKey = "SBA_AIAGENT_APP_ID"
    static let userIdKey = "SBA_AIAGENT_USER_ID"
    static let sessionTokenKey = "SBA_AIAGENT_SESSION_TOKEN"
    static let aiAgentIdKey = "SBA_AIAGENT_AI_AGENT_ID"
    static let channelURLKey = "SBA_AIAGENT_CHANNEL_URL"
    static let restBaseURLKey = "SBA_AIAGENT_REST_BASE_URL"
    static let webSocketURLKey = "SBA_AIAGENT_WS_URL"
    static let scenarioKey = "SBA_AIAGENT_SCENARIO"

    // Suite-level constants forwarded from the active `.xctestplan`'s
    // `defaultOptions.environmentVariableEntries`. Test plan env entries are
    // set directly on the test runner's process env (no `TEST_RUNNER_`
    // prefix stripping — that strip only applies to env vars passed on the
    // `xcodebuild` command line). The plan declares plain `SBA_SUITE_*`
    // keys; `MockQASupport.suiteEnvironment` forwards them into the host
    // app's launch environment so this file can read them via `ProcessInfo`.
    static let presentationKey = "SBA_SUITE_PRESENTATION"

    /// Optional. When set, the host assigns it to `SBAFontSet.fontFamily`
    /// before presenting, so a suite can render under a custom font family
    /// (TC-CPE-15 checks Japanese glyph forms under one). Absent or empty
    /// leaves the SDK on the system font.
    static let fontFamilyKey = "SBA_AIAGENT_FONT_FAMILY"

    /// Optional. Host overrides used by record-mode launches whose application
    /// does not live on the SDK's default hosts. Playback ignores these — it
    /// always routes at the mock server.
    static let liveAPIHostKey = "SBA_AIAGENT_LIVE_API_HOST"
    static let liveWSHostKey = "SBA_AIAGENT_LIVE_WS_HOST"

    /// Optional. `"1"` asks the SDK to publish message cells to the
    /// accessibility tree without VoiceOver, so a UI test can read message
    /// text. Debug builds only — see `SBAAccessibilityHelper`.
    static let exposeAccessibilityTreeKey = "SBA_AIAGENT_EXPOSE_A11Y_TREE"

    let runMode: RunMode
    let presentation: PresentationKind
    let appId: String
    let userId: String
    let sessionToken: String
    let aiAgentId: String
    let channelURL: String
    let restBaseURL: URL
    let webSocketURL: URL
    let scenario: String
    let fontFamily: String?
    let liveAPIHost: String?
    let liveWSHost: String?
    let exposesAccessibilityTree: Bool

    static func load(
        from environment: [String: String] = ProcessInfo.processInfo.environment
    ) throws -> AIAgentMockLaunchConfiguration? {
        // The scenario id is the host's signal that this launch is a mock UI
        // test. Without it we treat the launch as a regular QuickStart run and
        // hand control back to the normal startup path.
        guard let scenario = nonEmptyValue(for: scenarioKey, in: environment) else {
            return nil
        }

        let runModeValue = nonEmptyValue(for: runModeKey, in: environment) ?? "playback"
        guard let runMode = RunMode(rawValue: runModeValue) else {
            throw ConfigurationError.unsupportedRunMode(runModeValue)
        }

        let presentation = try requiredPresentation(in: environment)

        return AIAgentMockLaunchConfiguration(
            runMode: runMode,
            presentation: presentation,
            appId: try requiredValue(for: appIdKey, in: environment),
            userId: try requiredValue(for: userIdKey, in: environment),
            sessionToken: try requiredValue(for: sessionTokenKey, in: environment),
            aiAgentId: try requiredValue(for: aiAgentIdKey, in: environment),
            channelURL: try requiredValue(for: channelURLKey, in: environment),
            restBaseURL: try requiredURL(
                for: restBaseURLKey,
                in: environment,
                expectedSchemes: ["http", "https"]
            ),
            webSocketURL: try requiredURL(
                for: webSocketURLKey,
                in: environment,
                expectedSchemes: ["ws", "wss"]
            ),
            scenario: scenario,
            fontFamily: nonEmptyValue(for: fontFamilyKey, in: environment),
            liveAPIHost: nonEmptyValue(for: liveAPIHostKey, in: environment),
            liveWSHost: nonEmptyValue(for: liveWSHostKey, in: environment),
            exposesAccessibilityTree: nonEmptyValue(for: exposeAccessibilityTreeKey, in: environment) == "1"
        )
    }

    private static func requiredValue(
        for key: String,
        in environment: [String: String]
    ) throws -> String {
        guard let value = nonEmptyValue(for: key, in: environment) else {
            throw ConfigurationError.missingValue(key)
        }
        return value
    }

    private static func requiredURL(
        for key: String,
        in environment: [String: String],
        expectedSchemes: [String]
    ) throws -> URL {
        let value = try requiredValue(for: key, in: environment)
        guard let url = URL(string: value), let scheme = url.scheme else {
            throw ConfigurationError.invalidURL(key: key, value: value)
        }
        guard expectedSchemes.contains(scheme) else {
            throw ConfigurationError.unsupportedURLScheme(
                key: key,
                value: value,
                expectedSchemes: expectedSchemes
            )
        }
        return url
    }

    private static func requiredPresentation(
        in environment: [String: String]
    ) throws -> PresentationKind {
        // PresentationKind is intentionally open-set: a new test plan can
        // introduce a new presentation value without touching this file.
        // The host's `presentTargetView` switch carries the dispatch
        // responsibility and asserts on unknown values at use time.
        let value = try requiredValue(for: presentationKey, in: environment)
        return PresentationKind(rawValue: value)
    }

    private static func nonEmptyValue(
        for key: String,
        in environment: [String: String]
    ) -> String? {
        guard let value = environment[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty
        else {
            return nil
        }
        return value
    }
}

/// Identifies which UI surface a scenario lands on after the SDK initializes.
/// Driven by the active `.xctestplan`'s `SBA_SUITE_PRESENTATION` env var and
/// consumed by `AIAgentMockTestHost.presentTargetView`.
struct PresentationKind: RawRepresentable, Equatable {
    let rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }

    static let conversation     = PresentationKind(rawValue: "conversation")
    static let conversationList = PresentationKind(rawValue: "conversationList")
}
