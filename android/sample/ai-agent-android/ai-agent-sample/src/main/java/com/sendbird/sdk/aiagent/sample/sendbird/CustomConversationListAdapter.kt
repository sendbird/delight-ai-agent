package com.sendbird.sdk.aiagent.sample.sendbird

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Color
import android.view.ViewGroup
import android.widget.Toast

import androidx.recyclerview.widget.RecyclerView
import com.sendbird.sdk.aiagent.common.interfaces.OnItemClickListener
import com.sendbird.sdk.aiagent.messenger.model.conversation.ConversationListItem
import com.sendbird.sdk.aiagent.messenger.model.conversation.ConversationListUIParams
import com.sendbird.sdk.aiagent.messenger.ui.recyclerview.ConversationListAdapter
import com.sendbird.sdk.aiagent.messenger.ui.recyclerview.viewholder.ConversationViewHolder
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils

internal class CustomConversationListAdapter(
    conversationListUIParams: ConversationListUIParams,
    onItemClickListener: OnItemClickListener<ConversationListItem>,
) : ConversationListAdapter(conversationListUIParams, onItemClickListener) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ConversationViewHolder {
        val holder = super.onCreateViewHolder(parent, viewType)
        holder.itemView.setOnLongClickListener {
            val position = holder.bindingAdapterPosition
            if (position == RecyclerView.NO_POSITION) return@setOnLongClickListener false
            val item = getItem(position)
            if (item is ConversationListItem.ConversationItem) {
                val context = it.context
                val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                clipboard.setPrimaryClip(ClipData.newPlainText("Channel URL", item.channelUrl))
                Toast.makeText(context, "Channel URL copied", Toast.LENGTH_SHORT).show()
            }
            true
        }
        return holder
    }

    override fun onBindViewHolder(holder: ConversationViewHolder, position: Int) {
        super.onBindViewHolder(holder, position)
        val item = getItem(position)
        if (item is ConversationListItem.ConversationItem) {
            val isPinned = PreferenceUtils.pinnedChannelUrls.contains(item.channelUrl)
            // The child ConstraintLayout inside ConversationItemView(FrameLayout) has an opaque background,
            // so we need to change the background of the child view instead of itemView
            val contentView = (holder.itemView as? ViewGroup)?.getChildAt(0)
            contentView?.setBackgroundColor(
                if (isPinned) 0x1A4A90D9 else Color.TRANSPARENT
            )
        }
    }
}
