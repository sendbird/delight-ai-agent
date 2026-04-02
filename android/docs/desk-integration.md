# Desk integration

In Delight AI agent, when a conversation has been handed off to Sendbird Desk, you can retrieve Desk ticket information directly from the AI Agent SDK. This allows you to access ticket details — such as status, priority, assigned agent, and custom fields — without integrating a separate Desk SDK.

> ℹ️ **Note:** Desk ticket information is only available for conversations that have been handed off to Desk. The channel must have a linked Desk ticket for this feature to work.

This guide covers:
- [Retrieve a Desk ticket](#retrieve-a-desk-ticket)
- [Refresh ticket data](#refresh-ticket-data)
- [API references](#api-references)
- [Limitations](#limitations)

---

## Retrieve a Desk ticket

You can retrieve a Desk ticket by its ID using the `getTicket` method. The ticket ID is available through `channel.conversation?.handoff?.ticketId` when a conversation has been handed off to Desk. The `getTicket` method is a suspend function that must be called from a coroutine scope.

```kotlin
import com.sendbird.sdk.aiagent.messenger.model.desk.DeskTicket

if (channel.conversation?.handoff?.type == "sendbird_desk") {
    val ticketId = channel.conversation?.handoff?.ticketId?.toLongOrNull() ?: return
    coroutineScope.launch {
        try {
            val ticket = DeskTicket.getTicket(ticketId)
            // Access ticket properties
            val status = ticket.status
            val priority = ticket.priority
            val assignedAgent = ticket.agent
        } catch (e: Exception) {
            // Handle error
        }
    }
}
```

---

## Refresh ticket data

To get the latest ticket data, call the `refresh` method on an existing `DeskTicket` instance. This updates the ticket object with the most recent information from the server.

```kotlin
coroutineScope.launch {
    try {
        ticket.refresh()
        // The ticket now contains updated data
        val updatedStatus = ticket.status
    } catch (e: Exception) {
        // Handle error
    }
}
```

---

## API references

### DeskTicket

The `DeskTicket` class represents a Sendbird Desk ticket linked to a conversation.

#### List of properties

| Property name | Type | Description |
|---|---|---|
| id | Long | The unique ID of the ticket. |
| title | String? | The title of the ticket, mapped from the channel name. |
| status | DeskTicket.Status | Indicates the current status of the ticket. |
| priority | DeskTicket.Priority | Indicates the priority level of the ticket. |
| agent | DeskTicket.Agent? | The agent currently assigned to the ticket. |
| group | Int | The auto-routing group identifier. |
| firstResponseTime | Int | The time in seconds until the first agent response. Returns `-1` if there is no response. |
| issuedAt | String? | The timestamp when the customer sent the first message. |
| customFields | Map<String, String> | Custom fields associated with the ticket. |

#### List of methods

| Method | Description |
|---|---|
| getTicket(ticketId: Long) | Retrieves a Desk ticket by its ID. Returns a `DeskTicket`. This is a static suspend function. |
| refresh() | Refreshes the ticket data with the latest information from the server. Returns the updated `DeskTicket`. This is a suspend function. |

### DeskTicket.Status

`DeskTicket.Status` represents the status of a Desk ticket.

#### List of values

| Value | Description |
|---|---|
| INITIALIZED | The ticket has been created but not yet processed. |
| PENDING | The ticket is yet to be assigned to an agent because all agents are busy or there are no available online agents. |
| ACTIVE | The ticket is assigned to an agent and involves active interactions between an agent and a customer. |
| PROACTIVE | The ticket was created by an agent initiating a conversation with a customer first. |
| WORK_IN_PROGRESS | The ticket is yet to be closed but is not currently active. This can be used to keep track of tickets that aren't active but aren't closed yet. |
| IDLE | The customer hasn't responded back for a set amount of time since the agent's last response. |
| CLOSED | The conversation between the agent and the customer has ended. |

> ℹ️ **Note:** To learn more about ticket statuses, refer to the [Ticket status](https://sendbird.com/docs/desk/guide/v1/tickets/ticket-status) page in Sendbird Desk documentation.

### DeskTicket.Priority

`DeskTicket.Priority` represents the priority level of a Desk ticket.

#### List of values

| Value | Description |
|---|---|
| LOW | Low priority. |
| MEDIUM | Medium priority. |
| HIGH | High priority. |
| URGENT | Urgent priority. |

### DeskTicket.Agent

`DeskTicket.Agent` represents the agent assigned to a Desk ticket.

#### List of properties

| Property name | Type | Description |
|---|---|---|
| userId | String | The Sendbird user ID of the agent. |
| name | String | The display name of the agent. |
| profileUrl | String | The URL of the agent's profile image. |

---

## Limitations

- This feature provides read-only access to ticket information. You can retrieve and refresh ticket data, but cannot create, update, or close tickets.
- This feature does not fully replace the Desk SDK. Ticket creation, agent actions, and real-time ticket events still require the Desk SDK.
- Desk ticket information is only available for conversations that have been handed off to Desk.