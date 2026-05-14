[![iOS Languages](https://img.shields.io/badge/iOS-007AFF?style=flat-square&logo=apple&logoColor=white)![iOS Version](https://img.shields.io/badge/1.14.0-grey.svg?style=flat-square)](https://github.com/sendbird/delight-ai-agent-messenger-ios/releases)

## How to Customize the User Memory Dialog Style

On iOS, the user memory dialogs are rendered by the SDK's **shared confirm alert component**. Customizing it via `SBATheme` and `AIAgentMessenger.config` updates the user memory dialogs **and every other confirm-style alert** in the SDK at once.

**Scope — alerts affected by this customization:**
- User memory consent dialog (shown the first time a memory is captured)
- User memory state dialog (shown when toggling memory on/off)
- Handoff confirmation alert
- Steward cancellation alert
- Any other confirm-style alert added later

**Customization surface:**
- **Theme** (`SBATheme.common.confirmAlert`) — colors and fonts
- **Config** (`AIAgentMessenger.config.common.confirmAlert`) — button border width

**Step 1: Customize Colors and Fonts via Theme**

Use `$property.update(...)` for colors and assign directly for fonts:

```swift
import SendbirdAIAgentMessenger
import UIKit

let confirmAlert = SBATheme.common.confirmAlert

// Negative button
confirmAlert.$negativeButtonTextColor.update(all: .systemBlue)
confirmAlert.$negativeButtonBackgroundColor.update(all: .clear)
confirmAlert.$negativeButtonBorderColor.update(all: .systemBlue)
confirmAlert.negativeButtonFont = .systemFont(ofSize: 16, weight: .medium)

// Positive button
confirmAlert.$positiveButtonTextColor.update(all: .white)
confirmAlert.$positiveButtonBackgroundColor.update(all: .systemBlue)
confirmAlert.$positiveButtonBorderColor.update(all: .clear)
confirmAlert.positiveButtonFont = .systemFont(ofSize: 16, weight: .semibold)
```

**Step 2: Customize Button Border Width via Config**

Border width is controlled by `AIAgentMessenger.config`:

```swift
AIAgentMessenger.config.common.confirmAlert.negativeButtonBorderWidth = 1.0
AIAgentMessenger.config.common.confirmAlert.positiveButtonBorderWidth = 0.0
```

**Notes:**
- Apply customization after SDK initialization and before presenting the messenger UI.
- Border **color** is on the theme; border **width** is on the config. Both must be set for a border to appear.
- Use `$property.update(...)` for colors so both light and dark modes are set; direct assignment only updates one scheme.
