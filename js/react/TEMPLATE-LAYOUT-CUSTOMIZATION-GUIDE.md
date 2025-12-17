# Template-Based Layout Component Customization Guide

This guide explains how to customize Delight AI agent Messenger’s UI by replacing or hiding layout components using React Context.

This guide explains:
- [Overview](#overview)
    - [How template components work](#how-template-components-work)
- [Available layout components](#available-layout-components)
- [Component hierarchy and customization](#component-hierarchy-and-customization)
    - [IncomingMessageLayout](#incomingmessagelayout)
    - [OutgoingMessageLayout](#outgoingmessagelayout)
    - [SystemMessageLayout](#systemmessagelayout)
    - [ConversationLayout](#conversationlayout)
    - [ConversationHeaderLayout](#conversationheaderlayout)
    - [ConversationListHeaderLayout](#conversationlistheaderlayout)
    - [PlaceholderLayout](#placeholderlayout)
- [Putting it all together](#putting-it-all-together)
- [Best practices](#best-practices)

---

## Overview

**Delight AI agent Messenger React SDK** provides a powerful template-based layout system that allows for deep customization of UI components while maintaining the core functionality. This system uses a composition pattern where each layout component exposes a template and sub-components that can be individually customized or replaced.

### How template components work

Each layout component in the SDK follows a consistent pattern:

1. **Template**: The main layout structure that orchestrates how sub-components are arranged
2. **Context**: Provides access to the template and components through `useContext()`
3. **Components**: Individual sub-components that can be customized independently

The template system uses React Context to inject custom components, allowing you to:
- Replace individual sub-components while keeping the rest of the layout intact
- Hide unwanted components by returning `<></>` (or `null`)
- Maintain the original layout structure while changing specific behaviors

**Note**: All layout customizations must be wrapped within `AgentProviderContainer` along with the `Conversation` component to function properly. The examples below show individual component customizations, but see the [Putting It All Together](#putting-it-all-together) section for the complete integration pattern.

---

## Available layout components

The SDK provides several main layout categories for customization:

- **IncomingMessageLayout**: Handles the display of messages received from AI agents or other users
- **OutgoingMessageLayout**: Controls the rendering of messages sent by the current user
- **SystemMessageLayout**: Manages system-generated messages like admin messages and CSAT surveys
- **ConversationLayout**: Orchestrates the overall conversation view structure
- **ConversationHeaderLayout**: Controls the conversation header with customizable areas and buttons
- **ConversationListLayout**: Controls the list view of multiple conversations
- **ConversationListHeaderLayout**: Controls the conversation list header with customizable areas and buttons
- **PlaceholderLayout**: Handles various placeholder states (loading, error, empty states)

---

## Component hierarchy and customization

### IncomingMessageLayout

The `IncomingMessageLayout` provides the most extensive customization options with these sub-components:

```tsx
IncomingMessageLayout.components = {
  SenderName,        // Display sender's name
  SenderAvatar,      // Display sender's avatar
  SentTime,          // Show message timestamp
  MessageBody,       // Main message content
  TypingIndicator,   // Typing animation
  SuggestedReplies,  // Quick reply buttons
  MessageTemplate,   // Rich message templates
  CTAButton,         // Call-to-action buttons
  Citation,          // Reference citations
  Form,              // Interactive forms
  MessageLogs,       // Debug/log information
}
```

#### Basic customization example

You can customize individual components by providing custom implementations:

```tsx
import { IncomingMessageLayout, IncomingMessageProps } from '@sendbird/ai-agent-messenger-react';

// Custom message body with enhanced styling
const CustomMessageBody = (props: IncomingMessageProps) => {
  return (
    <div style={{ backgroundColor: '#f0f0f0', padding: '12px' }}>
      {props.message}
    </div>
  );
};

// Apply customization
export const CustomIncomingMessage = () => {
  return (
    <AgentProviderContainer>
      <IncomingMessageLayout.MessageBody component={CustomMessageBody} />
      <Conversation />
    </AgentProviderContainer>
  );
};
```

If you want to provide a completely custom template structure, define your custom template and pass it to `IncomingMessageLayout.Template` using the `template` prop to replace the entire layout:

```tsx
const CustomIncomingTemplate = (props: IncomingMessageProps) => {
  const { components } = IncomingMessageLayout.useContext();

  return (
    <div style={{ display: 'flex', flexDirection: 'column' }}>
      <div>Custom Layout Header</div>
      <components.MessageBody {...props} />
      <components.SentTime {...props} />
    </div>
  );
};

export const CustomIncomingMessage = () => {
  return (
    <IncomingMessageLayout.Template template={CustomIncomingTemplate}>
      <IncomingMessageLayout.SenderName component={CustomSenderName} />
    </IncomingMessageLayout.Template>
  );
};
```

#### Advanced customization - hiding components

```tsx
// Define an empty component to hide unwanted UI elements
const EmptyComponent = () => <></>;

export const MinimalIncomingMessage = () => {
  return (
    <IncomingMessageLayout.Template>
      {/* Hide these components by providing an empty component */}
      <IncomingMessageLayout.SenderAvatar component={EmptyComponent} />
      <IncomingMessageLayout.SenderName component={EmptyComponent} />
      <IncomingMessageLayout.SentTime component={EmptyComponent} />
    </IncomingMessageLayout.Template>
  );
};
```

### OutgoingMessageLayout

The `OutgoingMessageLayout` has a simpler structure with these components:

```tsx
OutgoingMessageLayout.components = {
  SendingStatus,  // Show sending/sent/failed status
  SentTime,       // Display timestamp
  MessageBody,    // Message content
}
```

#### Customization example

You can create a custom template to completely control the layout structure:

```tsx
import { OutgoingMessageLayout, OutgoingMessageProps } from '@sendbird/ai-agent-messenger-react';

const OutgoingMessageTemplate = (props: OutgoingMessageProps) => {
  const { components } = OutgoingMessageLayout.useContext();

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end' }}>
      <components.MessageBody {...props} />
      {props.sendingStatus === 'failed' && (
        <span style={{ color: 'red', fontSize: '12px' }}>Failed to send</span>
      )}
      <components.SentTime {...props} />
    </div>
  );
};

export const CustomOutgoingMessage = () => {
  return <OutgoingMessageLayout.Template template={OutgoingMessageTemplate} />;
};
```

### SystemMessageLayout

The `SystemMessageLayout` manages system-generated messages like admin messages and CSAT surveys:

```tsx
SystemMessageLayout.components = {
  AdminMessage,  // General system messages
  CSATMessage,   // Customer satisfaction surveys
}
```

#### Customization example

```tsx
import { SystemMessageLayout, SystemMessageProps } from '@sendbird/ai-agent-messenger-react';

const CustomAdminMessage = (props: SystemMessageProps) => {
  if (props.messageType !== 'admin') return null;

  return (
    <div style={{ textAlign: 'center', padding: '8px', color: '#666' }}>
      {props.message}
    </div>
  );
};

const CustomCSATMessage = (props: SystemMessageProps) => {
  if (props.messageType !== 'admin.csat') return null;

  return (
    <div style={{ padding: '16px' }}>
      <h3>Rate your experience</h3>
      {/* Custom rating UI */}
    </div>
  );
};

export const CustomSystemMessages = () => {
  return (
    <>
      <SystemMessageLayout.AdminMessage component={CustomAdminMessage} />
      <SystemMessageLayout.CSATMessage component={CustomCSATMessage} />
    </>
  );
};
```

### ConversationLayout

The `ConversationLayout` orchestrates the overall conversation view structure:

```tsx
ConversationLayout.components = {
  Header,  // Conversation header/title bar
  Body,    // Message list container
  Footer,  // Input area and controls
}
```

#### Customization example

```tsx
import { ConversationLayout } from '@sendbird/ai-agent-messenger-react';

const CustomHeader = () => {
  return (
    <div style={{ padding: '16px', backgroundColor: '#2c3e50', color: 'white' }}>
      <h2>AI Support Chat</h2>
    </div>
  );
};

const CustomFooter = () => {
  return (
    <div style={{ padding: '16px' }}>
      <input type="text" placeholder="Type your message..." />
    </div>
  );
};

export const CustomConversation = () => {
  return (
    <>
      <ConversationLayout.Header component={CustomHeader} />
      <ConversationLayout.Footer component={CustomFooter} />
    </>
  );
};
```

### ConversationHeaderLayout

The `ConversationHeaderLayout` controls the conversation header with customizable areas and buttons:

```tsx
ConversationHeaderLayout.components = {
  StartArea,                 // Left section (contains MenuButton by default)
  TitleArea,                 // Center section (contains Title by default)
  EndArea,                   // Right section (contains action buttons by default)
  MenuButton,                // Menu/navigation button
  Title,                     // Conversation title
  HandoffButton,             // Agent handoff button
  ConversationCloseButton,   // Close conversation button
  ExpandButton,              // Expand/fullscreen button
  CloseButton,               // Close widget button
}
```

The template accepts these props:

```tsx
interface ConversationHeaderTemplateProps {
  titleAlign?: 'start' | 'center' | 'end';  // Controls title alignment
}
```

#### Customization example - updating title

You can customize the title area and adjust title alignment using the default template:

```tsx
import { ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const CustomTitleArea = () => {
  return (
    <div style={{ fontWeight: 'bold', fontSize: '18px' }}>
      {'Custom Support Chat'}
    </div>
  );
};

const CustomTemplate = () => {
  // Use default template with center-aligned title
  return <ConversationHeaderLayout.defaults.template titleAlign={'center'} />;
};

export const CustomConversationHeader = () => {
  return (
    <ConversationHeaderLayout.Template template={CustomTemplate}>
      <ConversationHeaderLayout.TitleArea component={CustomTitleArea} />
    </ConversationHeaderLayout.Template>
  );
};
```

#### Customization example - updating start/end items

You can hide specific buttons or customize the start/end areas:

```tsx
import { ConversationHeaderLayout } from '@sendbird/ai-agent-messenger-react';

// Hide menu button by providing an empty component
const EmptyComponent = () => <></>;

// Custom end area with selected buttons
const CustomEndArea = () => {
  const { components } = ConversationHeaderLayout.useContext();
  return (
    <div style={{ display: 'flex', gap: '10px' }}>
      <components.HandoffButton />
      <components.CloseButton />
    </div>
  );
};

export const CustomConversationHeader = () => {
  return (
    <ConversationHeaderLayout.Template>
      <ConversationHeaderLayout.MenuButton component={EmptyComponent} />
      <ConversationHeaderLayout.EndArea component={CustomEndArea} />
    </ConversationHeaderLayout.Template>
  );
};
```

### ConversationListHeaderLayout

The `ConversationListHeaderLayout` controls the conversation list header with customizable areas and buttons:

```tsx
ConversationListHeaderLayout.components = {
  StartArea,   // Left section (empty by default)
  TitleArea,   // Center section (contains Title by default)
  EndArea,     // Right section (contains CloseButton by default)
  Title,       // Conversation list title
  CloseButton, // Close widget button
}
```

The template accepts these props:

```tsx
interface ConversationListHeaderTemplateProps {
  titleAlign?: 'start' | 'center' | 'end';  // Controls title alignment
}
```

#### Customization example - updating title

```tsx
import { ConversationListHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const CustomTitle = () => {
  return (
    <div style={{ fontWeight: 'bold', fontSize: '20px' }}>
      {'My Conversations'}
    </div>
  );
};

const CustomTemplate = () => {
  return <ConversationListHeaderLayout.defaults.template titleAlign={'center'} />;
};

export const CustomConversationListHeader = () => {
  return (
    <ConversationListHeaderLayout.Template template={CustomTemplate}>
      <ConversationListHeaderLayout.Title component={CustomTitle} />
    </ConversationListHeaderLayout.Template>
  );
};
```

#### Customization example - updating start/end items

```tsx
import { ConversationListHeaderLayout } from '@sendbird/ai-agent-messenger-react';

const EmptyComponent = () => <></>;

const CustomStartArea = () => {
  return (
    <button onClick={() => console.log('Menu clicked')}>
      {'☰'}
    </button>
  );
};

export const CustomConversationListHeader = () => {
  return (
    <ConversationListHeaderLayout.Template>
      <ConversationListHeaderLayout.StartArea component={CustomStartArea} />
      <ConversationListHeaderLayout.CloseButton component={EmptyComponent} />
    </ConversationListHeaderLayout.Template>
  );
};
```

### PlaceholderLayout

The `PlaceholderLayout` handles various placeholder states (loading, error, empty states):

```tsx
PlaceholderLayout.components = {
  Loading,     // Loading state, use PlaceholderLoadingProps type
  Error,       // Error state, use PlaceholderErrorProps type
  NoChannels,  // Empty conversation list, use PlaceholderBaseProps type
  NoMessages,  // Empty message list, use PlaceholderBaseProps type
}
```

#### Customization example

```tsx
import { PlaceholderLayout, PlaceholderLoadingProps, PlaceholderErrorProps } from '@sendbird/ai-agent-messenger-react';

const CustomLoading = (props: PlaceholderLoadingProps) => {
  return <div>Loading conversations...</div>;
};

const CustomError = (props: PlaceholderErrorProps) => {
  return (
    <div>
      <h3>Something went wrong</h3>
      <p>{props.action?.label}</p>
      <button onClick={props.action?.onClick}>{'Retry'}</button>
    </div>
  );
};

export const CustomPlaceholders = () => {
  return (
    <PlaceholderLayout.Template>
      <PlaceholderLayout.Loading component={CustomLoading} />
      <PlaceholderLayout.Error component={CustomError} />
    </PlaceholderLayout.Template>
  );
};
```

---

## Putting it all together

After defining your custom components, you need to provide them to the SDK. All layout customizations should be wrapped within `AgentProviderContainer`:

```tsx
import {
  AgentProviderContainer,
  Conversation,
  IncomingMessageLayout,
  OutgoingMessageLayout,
  SystemMessageLayout,
  ConversationLayout,
  ConversationHeaderLayout,
  IncomingMessageProps,
  OutgoingMessageProps,
  SystemMessageProps,
} from '@sendbird/ai-agent-messenger-react';

// Your custom components
const CustomMessageBody = (props: IncomingMessageProps) => { /* ... */ };
const OutgoingMessageTemplate = (props: OutgoingMessageProps) => { /* ... */ };
const CustomAdminMessage = (props: SystemMessageProps) => { /* ... */ };
const CustomFooter = () => { /* ... */ };
const CustomTitleArea = () => { /* ... */ };
const EmptyComponent = () => <></>;

export const MyCustomMessenger = () => {
  return (
    <AgentProviderContainer appearance={{ theme: 'light' }}>
      {/* Apply all customizations */}
      <IncomingMessageLayout.Template>
        <IncomingMessageLayout.MessageBody component={CustomMessageBody} />
        <IncomingMessageLayout.SenderAvatar component={EmptyComponent} />
      </IncomingMessageLayout.Template>

      <OutgoingMessageLayout.Template template={OutgoingMessageTemplate} />

      <SystemMessageLayout.AdminMessage component={CustomAdminMessage} />

      <ConversationLayout.Footer component={CustomFooter} />

      <ConversationHeaderLayout.Template>
        <ConversationHeaderLayout.TitleArea component={CustomTitleArea} />
        <ConversationHeaderLayout.MenuButton component={EmptyComponent} />
      </ConversationHeaderLayout.Template>

      {/* Conversation component renders the actual chat UI */}
      <Conversation channelUrl={'your-channel-url'} />
    </AgentProviderContainer>
  );
};
```

---

## Best practices

1. **Maintain Prop Compatibility**: When creating custom components, ensure they accept and handle the same props as the default components.

2. **Hiding Components**: To hide a component, pass an empty fragment (e.g., `const EmptyComponent = () => <></>`). If you omit the component prop entirely, the default UI will be rendered instead.

3. **Preserve Context Access**: Custom components can access the layout context using `LayoutName.useContext()` to get access to other components.

4. **Style Consistently**: Maintain visual consistency with your application's design system while customizing components.

5. **Handle All Message Types**: Ensure custom message body components handle different message types (text, file, image, etc.).
