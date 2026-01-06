[![Android Languages](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Android Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)]()

## Steps to Customize Conversation List Items
**Step 1: Create a Custom Layout for the List Item**

Define your desired UI layout in an XML file (e.g., view_custom_conversation_list_item.xml).
This layout will replace the default conversation list item.

**Step 2: Create a Custom ViewHolder**

Extend ConversationViewHolder and bind your custom layout using ViewBinding.
Handle UI rendering and click events within this ViewHolder.

```kotlin
class CustomConversationViewHolder(...) : ConversationViewHolder(...) {
    override fun bind(conversationListItem: ConversationListItem) {
        // Bind your data here
    }
}
```

**Step 3: Extend ConversationListAdapter and Use the Custom ViewHolder**

Override onCreateViewHolder to return your custom ViewHolder.

```kotlin
class CustomConversationListAdapter(
    private val conversationListUIParams: ConversationListUIParams,
    private val onItemClickListener: OnItemClickListener<ConversationListItem>
) : ConversationListAdapter(conversationListUIParams, onItemClickListener) {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ConversationViewHolder {
        return  CustomConversationViewHolder(...)
    }
}
```

**Step 4: Register the Custom Adapter with AIAgentAdapterProviders**

Finally, register your adapter before rendering the Conversation screen:

```kotlin
AIAgentAdapterProviders.conversationList =
    ConversationListAdapterProvider { uiParams, onItemClickListener ->
        CustomConversationListAdapter(uiParams, onItemClickListener)
    }
```
