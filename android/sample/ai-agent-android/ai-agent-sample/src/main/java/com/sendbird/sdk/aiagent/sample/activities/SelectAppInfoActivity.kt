package com.sendbird.sdk.aiagent.sample.activities

import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.sendbird.sdk.aiagent.sample.R
import com.sendbird.sdk.aiagent.sample.consts.Region
import com.sendbird.sdk.aiagent.sample.databinding.SampleLayoutSelectAppInfoBinding
import com.sendbird.sdk.aiagent.sample.model.SampleAppInfo
import com.sendbird.sdk.aiagent.sample.model.no1
import com.sendbird.sdk.aiagent.sample.model.no2
import com.sendbird.sdk.aiagent.sample.model.no3
import com.sendbird.sdk.aiagent.sample.model.no4
import com.sendbird.sdk.aiagent.sample.model.no5
import com.sendbird.sdk.aiagent.sample.model.no6
import com.sendbird.sdk.aiagent.sample.model.us3
import com.sendbird.sdk.aiagent.sample.utils.PreferenceUtils
import com.sendbird.sdk.aiagent.sample.utils.apiHost
import com.sendbird.sdk.aiagent.sample.utils.awaitInitializeMessenger
import com.sendbird.sdk.aiagent.sample.utils.toRegion
import com.sendbird.sdk.aiagent.sample.utils.wsHost
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class SelectAppInfoActivity : BaseSampleActivity() {
    private lateinit var appInfo: SampleAppInfo
    override val binding by lazy { SampleLayoutSelectAppInfoBinding.inflate(layoutInflater) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        with(binding) {
            setContentView(root)
            val spinnerItems = resources.getStringArray(R.array.sb_regions)
            val myAdapter = ArrayAdapter(this@SelectAppInfoActivity, R.layout.spinner_dropdown_item_dark, spinnerItems).apply {
                setDropDownViewResource(R.layout.spinner_dropdown_item_dark)
            }
            sRegion.adapter = myAdapter
            sRegion.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(parent: AdapterView<*>, view: View?, position: Int, id: Long) {
                    (view as? TextView)?.setTextColor(ContextCompat.getColor(this@SelectAppInfoActivity, R.color.white))
                    appInfo = getDefaultAppInfo(spinnerItems[position].toRegion(this@SelectAppInfoActivity))
                    setDefaultInformation(this@with, appInfo)
                }

                override fun onNothingSelected(parent: AdapterView<*>) {}
            }
            btnSave.setOnClickListener {
                val aiAgentId = etAIAgentId.text.toString()
                val appId = etAppId.text.toString()
                val context = this@SelectAppInfoActivity
                val apiHost = appInfo.region.apiHost() ?: "https://api-$appId.sendbird.com"
                val wsHost = appInfo.region.wsHost() ?: "wss://ws-$appId.sendbird.com"

                lifecycleScope.launch(Dispatchers.Default) {
                    runCatching {
                        context.awaitInitializeMessenger(appId, apiHost, wsHost)

                        // save local storage
                        PreferenceUtils.sampleAppInfo = appInfo.copy(
                            aiAgentId = aiAgentId,
                            appId = appId
                        )
                        withContext(Dispatchers.Main) {
                            startActivity(ViewMainActivity.newIntent(this@SelectAppInfoActivity, aiAgentId))
                            finish()
                        }
                    }.onFailure {
                        Toast.makeText(context, "Error: ${it.message}", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        }
    }

    private fun setDefaultInformation(binding: SampleLayoutSelectAppInfoBinding, appInfo: SampleAppInfo) {
        with(binding) {
            with(appInfo) {
                etAppId.setText(appId)
                etAIAgentId.setText(aiAgentId)
            }
        }
    }

    private fun getDefaultAppInfo(region: Region): SampleAppInfo {
        return when (region) {
            Region.PRODUCTION -> us3
            Region.NO1 -> no1
            Region.NO2 -> no2
            Region.NO3 -> no3
            Region.NO4 -> no4
            Region.NO5 -> no5
            Region.NO6 -> no6
        }
    }
}
