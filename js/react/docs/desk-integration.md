# Desk integration

In Delight AI agent, when a conversation has been handed off to Sendbird Desk, you can retrieve Desk ticket information directly from the AI Agent SDK. This allows you to access ticket details — such as status, priority, assigned agent, and custom fields — without integrating a separate Desk SDK.

> ℹ️ Desk ticket information is only available for conversations that have been handed off to Desk. The channel must have a linked Desk ticket for this feature to work.

This guide covers:
- [Retrieve a Desk ticket](#retrieve-a-desk-ticket)
- [Refresh ticket data](#refresh-ticket-data)
- [API references](#api-references)
- [Limitations](#limitations)

---

## Retrieve a Desk ticket

You can retrieve a Desk ticket by its ID using the `getTicket` method on the `deskClient` from `useAIAgentContext()`. The ticket ID is available through `channel.conversation?.handoff?.ticketId` when a conversation has been handed off to Desk.

```typescript
const { deskClient } = useAIAgentContext();

if (channel.conversation?.handoff?.type === "sendbird_desk") {
  const ticketId = Number(channel.conversation?.handoff?.ticketId);
  if (!ticketId) return;

  const ticket = await deskClient.getTicket(ticketId);
  // Access ticket properties
  const status = ticket.status;
  const priority = ticket.priority;
  const assignedAgent = ticket.agent;
}
```

---

## Refresh ticket data

To get the latest ticket data, call the `refresh` method on an existing `DeskTicket` instance. This method returns a new `DeskTicket` instance with the most recent information from the server.

```typescript
const updatedTicket = await ticket.refresh();
// The updatedTicket contains the latest data
const updatedStatus = updatedTicket.status;
```

---

## API references

### DeskClient

The `DeskClient` class provides methods to interact with Sendbird Desk tickets. Access it through the `useAIAgentContext()` hook.

#### List of methods

| Method | Description |
|---|---|
| getTicket(id: number) | Retrieves a Desk ticket by its ID. Returns a `Promise<DeskTicketInterface>`. |

### DeskTicket

`DeskTicket` represents a Sendbird Desk ticket linked to a conversation.

#### List of properties

| Property name | Type | Description |
|---|---|---|
| id | number | The unique ID of the ticket. |
| title | string \| null | The title of the ticket, mapped from the channel name. |
| status | DeskTicketStatus | Indicates the current status of the ticket. |
| priority | DeskTicketPriority | Indicates the priority level of the ticket. |
| agent | DeskTicketAgent \| null | The agent currently assigned to the ticket. |
| group | number | The auto-routing group identifier. |
| firstResponseTime | number | The time in seconds until the first agent response. Returns `-1` if there is no response. |
| issuedAt | string \| null | The timestamp when the customer sent the first message. |
| customFields | Record<string, string> | Custom fields associated with the ticket. |

#### List of methods

| Method | Description |
|---|---|
| refresh() | Refreshes the ticket data with the latest information from the server. Returns a `Promise<DeskTicketInterface>` with a new instance. |

### DeskTicketStatus

`DeskTicketStatus` represents the status of a Desk ticket.

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

> ℹ️ To learn more about ticket statuses, refer to the [Ticket status](https://sendbird.com/docs/desk/guide/v1/tickets/ticket-status) page in Sendbird Desk documentation.

### DeskTicketPriority

`DeskTicketPriority` represents the priority level of a Desk ticket.

#### List of values

| Value | Description |
|---|---|
| LOW | Low priority. |
| MEDIUM | Medium priority. |
| HIGH | High priority. |
| URGENT | Urgent priority. |

### DeskTicketAgent

`DeskTicketAgent` represents the agent assigned to a Desk ticket.

#### List of properties

| Property name | Type | Description |
|---|---|---|
| userId | string | The Sendbird user ID of the agent. |
| name | string | The display name of the agent. |
| profileUrl | string | The URL of the agent's profile image. |

---

## Limitations

- This feature provides read-only access to ticket information. You can retrieve and refresh ticket data, but cannot create, update, or close tickets.
- This feature does not fully replace the Desk SDK. Ticket creation, agent actions, and real-time ticket events still require the Desk SDK.
- Desk ticket information is only available for conversations that have been handed off to Desk.
