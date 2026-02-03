[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)![Version](https://img.shields.io/badge/1.3.0-grey.svg?style=flat-square)](https://github.com/sendbird/ai-agent-messenger-android/releases)

## Steps to Customize the Header

This guide demonstrates how to insert custom data at the top of the conversation list.

**Step 1: Extend the Repository to Add Custom Items**

To include custom data (e.g., a system notice, a pinned info card, or a static banner), override the DefaultConversationListRepository and manually prepend the item to the list before rendering.

```kotlin
class CustomConversationListRepository(
    aiAgentId: String
) : DefaultConversationListRepository(aiAgentId) {

    private val customItem: Any // Insert your desired custom data type here

    override suspend fun loadInitial() {
        // If you need to load any data, do so before calling super.loadInitial()
        super.loadInitial()
    }

    override val currentList: List<GroupChannel>
        get() {
            val list = super.currentList.toMutableList()
           // In this sample, the custom data is inserted at index 0 (top of the list).
           // If you want to customize the list (e.g., insert at a different position, filter, or sort),
           // this is the place to do it.
            list.add(0, customHeaderItem)
            return list
        }
}
```

Then, register the repository:

AIAgentRepositoryProviders.conversationList =
    ConversationListRepositoryProvider { aiAgentId ->
        CustomConversationListRepository(aiAgentId)
    }

**Step 2: Customize the Adapter to Handle Custom Items**

To render your custom item, override getItemViewType() and onCreateViewHolder() in your adapter:

```kotlin
class CustomConversationListAdapter(...) : ConversationListAdapter(...) {

    override fun getItemViewType(position: Int): Int {
        return when (val item = getItem(position)) {
            is CustomHeaderItem -> CustomConversationListRepository.VIEW_TYPE_CUSTOM_HEADER
            is ConversationListItem.ConversationItem -> VIEW_TYPE_CONVERSATION
            else -> super.getItemViewType(position)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ConversationViewHolder {
        when (viewType) {
            VIEW_TYPE_CONVERSATION -> {
                return super.onCreateViewHolder(parent, viewType)
            }
            VIEW_TYPE_BROADCAST -> {
                // Create and return a custom ViewHolder for rendering broadcast or custom-type items
                return CustomConversationViewHolder(...)
            }
        }
    }

    companion object {
        const val VIEW_TYPE_CONVERSATION_DATA = 0
        const val VIEW_TYPE_CUSTOM_DATA = 1
    }
}
```

Register your adapter:
```kotlin
AIAgentAdapterProviders.conversationList =
    ConversationListAdapterProvider { uiParams, onItemClickListener ->
        CustomConversationListAdapter(uiParams, onItemClickListener)
    }
```
