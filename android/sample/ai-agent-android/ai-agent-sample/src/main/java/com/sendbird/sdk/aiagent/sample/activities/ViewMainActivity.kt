package com.sendbird.sdk.aiagent.sample.activities

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View.GONE
import android.view.View.VISIBLE
import android.widget.LinearLayout
import android.widget.Toast
import androidx.lifecycle.lifecycleScope
import com.sendbird.sdk.aiagent.common.extensions.addRipple
import com.sendbird.sdk.aiagent.common.extensions.aiAgentId
import com.sendbird.sdk.aiagent.messenger.AIAgentMessenger
import com.sendbird.sdk.aiagent.messenger.BuildConfig
import com.sendbird.sdk.aiagent.messenger.consts.LaunchMode
import com.sendbird.sdk.aiagent.messenger.model.LauncherLayoutParams
import com.sendbird.sdk.aiagent.messenger.model.LauncherLocation
import com.sendbird.sdk.aiagent.messenger.model.LauncherMargin
import com.sendbird.sdk.aiagent.messenger.model.LauncherSettingsParams
import com.sendbird.sdk.aiagent.messenger.providers.AIAgentAdapterProviders
import com.sendbird.sdk.aiagent.messenger.providers.AIAgentRepositoryProviders
import com.sendbird.sdk.aiagent.messenger.providers.ConversationListAdapterProvider
import com.sendbird.sdk.aiagent.messenger.providers.ConversationListRepositoryProvider
import com.sendbird.sdk.aiagent.messenger.ui.MessengerLauncher
import com.sendbird.sdk.aiagent.messenger.ui.activity.MessengerActivity
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.databinding.ActivityViewMainBinding
import com.sendbird.sdk.aiagent.sample.model.us3
import com.sendbird.sdk.aiagent.sample.sendbird.CustomConversationListRepository
import com.sendbird.sdk.aiagent.sample.sendbird.CustomConversationListAdapter
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ViewMainActivity : BaseSampleActivity() {
    override val binding: ActivityViewMainBinding by lazy { ActivityViewMainBinding.inflate(layoutInflater) }

    private val aiAgentId: String? by lazy { intent.extras.aiAgentId }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        registerProviders()
        initMessengerLauncher()
        setButtonForFullScreenAiAgent()
        initView()
    }

    override fun onResume() {
        super.onResume()
        initManualUserProfile()
        drawFingerPrint()
    }

    private fun initManualUserProfile() {
        with(binding.ivProfile) {
            visibility = if (PreferenceUtils.manualUserInfo == null) {
                setImageResource(R.drawable.sample_profile_icon)
                setOnClickListener {
                    startActivity(Intent(this@ViewMainActivity, LoginActivity::class.java))
                }
                VISIBLE
            } else {
                GONE
            }
            addRipple()
        }
    }

    private fun initMessengerLauncher() {
        aiAgentId?.let {
            val params = LauncherLayoutParams(
                LaunchMode.ANCHORED,
                LauncherMargin(12, 12, 12, 12),
                LauncherLocation.BOTTOM_END
            )
            MessengerLauncher(this, it, LauncherSettingsParams(layoutParams = params)).attach()
        } ?: run {
            Toast.makeText(this, R.string.aa_text_error_not_found_aiagent_id, Toast.LENGTH_SHORT).show()
            finishAffinity()
        }
    }

    private fun setButtonForFullScreenAiAgent() {
        binding.btnViewDemo.setOnClickListener {
            aiAgentId?.let {
                startActivity(MessengerActivity.newIntentForConversation(this, it))
            }
        }
    }

    private fun initView() {
        lifecycleScope.launch {
            binding.btnLogout.setOnClickListener {
                lifecycleScope.launch(Dispatchers.IO) {
                    PreferenceUtils.clearAll()
                    AIAgentMessenger.deauthenticate()
                    withContext(Dispatchers.Main) {
                        finishAffinity()
                        startActivity(Intent(this@ViewMainActivity, SelectAppInfoActivity::class.java))
                    }
                }
            }
            binding.btnSetPinnedChannels.setOnClickListener {
                showPinnedChannelDialog()
            }
        }
    }

    private fun registerProviders() {
        AIAgentRepositoryProviders.conversationList =
            ConversationListRepositoryProvider { aiAgentId ->
                CustomConversationListRepository(aiAgentId)
            }
        AIAgentAdapterProviders.conversationList =
            ConversationListAdapterProvider { uiParams, onItemClickListener ->
                CustomConversationListAdapter(uiParams, onItemClickListener)
            }
    }

    private fun showPinnedChannelDialog() {
        val dialogView = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(48, 32, 48, 16)
        }

        val listContainer = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
        }
        dialogView.addView(listContainer)

        val inputLayout = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
        }
        val editText = android.widget.EditText(this).apply {
            hint = "Channel URL"
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            setSingleLine(true)
        }
        val addButton = android.widget.Button(this).apply {
            text = "Add"
        }
        inputLayout.addView(editText)
        inputLayout.addView(addButton)
        dialogView.addView(inputLayout)

        val pinnedUrls = PreferenceUtils.pinnedChannelUrls.toMutableList()

        fun refreshList() {
            listContainer.removeAllViews()
            pinnedUrls.forEachIndexed { index, url ->
                val row = LinearLayout(this).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = android.view.Gravity.CENTER_VERTICAL
                    setPadding(0, 8, 0, 8)
                }
                val textView = android.widget.TextView(this).apply {
                    text = url
                    layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
                    setTextColor(android.graphics.Color.BLACK)
                    maxLines = 1
                    ellipsize = android.text.TextUtils.TruncateAt.MIDDLE
                }
                val removeButton = android.widget.Button(this).apply {
                    text = "X"
                    layoutParams = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                    setOnClickListener {
                        pinnedUrls.removeAt(index)
                        PreferenceUtils.pinnedChannelUrls = pinnedUrls
                        refreshList()
                    }
                }
                row.addView(textView)
                row.addView(removeButton)
                listContainer.addView(row)
            }
        }

        addButton.setOnClickListener {
            val url = editText.text.toString().trim()
            when {
                url.isBlank() -> Toast.makeText(this, "URL cannot be empty", Toast.LENGTH_SHORT).show()
                pinnedUrls.contains(url) -> Toast.makeText(this, "URL already added", Toast.LENGTH_SHORT).show()
                else -> {
                    pinnedUrls.add(url)
                    PreferenceUtils.pinnedChannelUrls = pinnedUrls
                    editText.text.clear()
                    refreshList()
                }
            }
        }

        refreshList()

        androidx.appcompat.app.AlertDialog.Builder(this)
            .setTitle("Set Pinned Channels")
            .setView(dialogView)
            .setPositiveButton("Close", null)
            .show()
    }

    private fun drawFingerPrint() {
        lifecycleScope.launch {
            val fingerPrint = withContext(Dispatchers.IO) {
                val region = (PreferenceUtils.sampleAppInfo ?: us3).region.name
                val fingerPrint = "${BuildConfig.VERSION_NAME} - [$region]"

                PreferenceUtils.manualUserInfo?.let {
                    "${fingerPrint}\t\t${it.userId}"
                } ?: fingerPrint
            }

            withContext(Dispatchers.Main) {
                binding.tvInformation.text = fingerPrint
            }
        }
    }

    companion object {
        private const val KEY_AI_AGENT_ID = "KEY_AI_AGENT_ID"
        internal fun newIntent(context: Context, aiAgentId: String): Intent {
            return Intent(context, ViewMainActivity::class.java).apply {
                putExtra(KEY_AI_AGENT_ID, aiAgentId)
            }
        }
    }
}
