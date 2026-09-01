//
//  AIAgentStarterKit+Customize.swift
//  QuickStart
//
//  Created by Tez Park on 5/17/25.
//

import SendbirdAIAgentMessenger
import UIKit
#if canImport(SendbirdUIKit)
import SendbirdUIKit
#endif

// MARK: - CustomSet
extension AIAgentStarterKit {
    /// Closure to customize global configuration settings.
    public static var globalConfigCustomizationBuilder: (() -> Void)?
    /// Closure to customize module-specific settings.
    public static var moduleSetCustomizationBuilder: (() -> Void)?
    /// Closure to customize context objects used throughout the agent.
    public static var contextObjectsBuilder: (() -> Void)?

    /// Renders suggested replies with ``MenuSuggestedReplyView`` instead of the default chips.
    ///
    /// Off by default, so QuickStart shows the SDK default. Flip it here, or from anywhere before
    /// the conversation screen is created, to try the sample.
    static var usesSuggestedReplyMenuSample = false

    /// Renders `custom` agent message templates with ``SampleASTemplateView``, which routes
    /// the AS selector (template 1) and the AS guide (template 2) by template id.
    ///
    /// On by default: an unregistered custom template renders nothing on iOS, so the sample is
    /// what makes the card visible at all once the dashboard sends the template.
    static var usesASSelectorSample = true

    /// Feeds the selector a local case catalog instead of calling the customer API.
    ///
    /// On by default because there is no endpoint to point at yet. Turn it off once a real
    /// catalog address is configured in the dashboard template payload.
    static var usesASSelectorTaxonomyStub = true

    /// Applies all custom configurations including global settings, module customizations, and context objects.
    ///
    /// This method should be called before presenting UI to ensure all customizations are applied.
    /// It executes the following builders in order:
    /// - `globalConfigCustomizationBuilder`: Global configuration settings
    /// - `moduleSetCustomizationBuilder`: Module-specific customizations
    /// - `contextObjectsBuilder`: Context object configurations
    static func applyCustomizations() {
        Self.applyIconCustomizations()
        Self.applySampleModules()
        Self.globalConfigCustomizationBuilder?()
        Self.moduleSetCustomizationBuilder?()
        Self.contextObjectsBuilder?()
    }

    // MARK: - Sample Modules

    /// Registers sample subclasses (e.g. `SampleChallengeView`) into the shared module set so
    /// the QuickStart shows the reference implementations by default. Host apps override any of
    /// these later via `moduleSetCustomizationBuilder`.
    ///
    /// Gated behind `INTERNAL_SAMPLE_CHALLENGE` so the public-quickstart target (which builds
    /// against the released SPM package) is not forced to reference symbols that only exist on
    /// this branch.
    private static func applySampleModules() {
        #if INTERNAL_SAMPLE_CHALLENGE
        SBAConversationModule.List.Cell.ChallengeView = SampleChallengeView.self
        #endif

        #if INTERNAL_SAMPLE_SUGGESTED_REPLY
        if Self.usesSuggestedReplyMenuSample {
            SBAConversationModule.List.Cell.SuggestedReplyView = MenuSuggestedReplyView.self
        }
        #endif

        #if INTERNAL_SAMPLE_CUSTOM_TEMPLATE
        if Self.usesASSelectorSample {
            // One slot, two templates. The view dispatches on the template id, and it sends
            // the picked path itself through `sendUserMessage(_:)`, so no conversation view
            // controller subclass is needed.
            SBAConversationModule.List.Cell.CustomMessageTemplateView = SampleASTemplateView.self

            if Self.usesASSelectorTaxonomyStub {
                SampleASCatalogLoader.stubJSON = SampleASCatalogLoader.debugStubJSON
            }
        }
        #endif
    }

    // MARK: - Icon
    /// Applies custom icon overrides for testing icon customization.
    ///
    /// ## Usage
    /// ```swift
    /// // Replace individual icons with custom images
    /// SBAIconSet.iconClose = UIImage(systemName: "xmark")!
    /// SBAIconSet.iconSend = UIImage(systemName: "paperplane.fill")!
    /// SBAIconSet.iconAdd = UIImage(systemName: "plus")!
    /// ```
    private static func applyIconCustomizations() {
        // NOTE: Uncomment the lines below to test icon customization
    }
    
    // MARK: - Theme
    /// Updates the theme of the Delight AI Agent Messenger with the specified color scheme.
    /// - Parameter colorScheme: The color scheme to apply to the AI Agent Messenger.
    static func updateAIAgentTheme(_ colorScheme: SBAColorScheme) {
        AIAgentMessenger.update(colorScheme: colorScheme)
    }
    
    /// Updates the theme of the Sendbird UIKit components with the specified color scheme.
    /// This method only applies if SendbirdUIKit is available.
    /// - Parameter colorScheme: The color scheme to apply to the UIKit components. Defaults to `.light`.
    static func updateUIKitTheme(_ colorScheme: SBAColorScheme = .light) {
        #if canImport(SendbirdUIKit)
        switch colorScheme {
        case .light: SBUTheme.set(colorScheme: .light)
        case .dark: SBUTheme.set(colorScheme: .dark)
        @unknown default:
            break
        }
    
        SBUTheme.channelTheme.leftBarButtonTintColor = colorScheme == .light ? .black : .white
        #endif
    }
}
