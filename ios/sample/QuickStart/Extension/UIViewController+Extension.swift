//
//  UIViewController+Extension.swift
//  AIAgentQuickStart
//
//  Created by Damon Park on 12/31/24.
//

import UIKit
import SendbirdChatSDK
import SendbirdAIAgentMessenger

extension UIViewController {
    func versionString() -> String  {
        let coreVersion: String = SendbirdChat.getSDKVersion()
        var aiagentVersion: String {
            switch AIAgentMessenger.shortVersion {
            case "1.6.0":
                let bundle = Bundle(identifier: "com.sendbird.aiagent.sample")
                return "\(bundle?.infoDictionary?["CFBundleShortVersionString"] ?? "")"
            case "0.0.0":
                guard let dictionary = Bundle.main.infoDictionary,
                      let appVersion = dictionary["CFBundleShortVersionString"] as? String,
                      let build = dictionary["CFBundleVersion"] as? String else { return "" }
                return "\(appVersion)(\(build))"
            default:
                return AIAgentMessenger.shortVersion
            }
        }
        return "DelightAI v\(aiagentVersion)\tSDK v\(coreVersion)"
    }
}
