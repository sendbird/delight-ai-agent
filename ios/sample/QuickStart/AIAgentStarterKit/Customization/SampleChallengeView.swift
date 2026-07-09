//
//  SampleChallengeView.swift
//  QuickStart
//
//  Created by Damon Park on 6/17/26.
//

#if INTERNAL_SAMPLE_CHALLENGE
import UIKit
import SendbirdAIAgentMessenger

/// Sample subclass of `SBAChallengeView` for verifying Challenge AMT end-to-end wiring.
///
/// Demonstrates the recommended lifecycle pattern for a `SBAChallengeView` subclass:
///
/// 1. **`setupViews()`** — instantiate subviews, build the view hierarchy, register actions.
///    The base class already calls this once at init; override to wire up your form structure.
/// 2. **`setupLayouts()`** — apply constraints / layout margins. Base class adds the message-cell
///    width constraint; subclasses add their own padding here.
/// 3. **`setupStyles()`** — apply colors / fonts / corner radii. Re-invoked whenever the view
///    needs to refresh its appearance (e.g. on theme change).
/// 4. **`configure(with:channelUrl:)`** — push challenge payload into subviews. Always call
///    `super.configure(...)` first so the base captures `challenge` / `channelUrl`.
///
/// The base class calls `setupViews → setupLayouts → setupStyles` from `configure(...)`, so a
/// host subclass only has to override these four hooks and never has to manage view-add ordering
/// directly.
final class SampleChallengeView: SBAChallengeView {

    // MARK: - Constants

    private enum Constants {
        static let backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.0)
        static let buttonColor = UIColor(red: 116 / 255, green: 45 / 255, blue: 221 / 255, alpha: 1.0)
        static let buttonTitleColor = UIColor.white
        static let labelTextColor = UIColor.label
        static let cornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 8
        static let stackSpacing: CGFloat = 8
        static let padding: CGFloat = 12
        static let buttonContentInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }

    // MARK: - Subviews

    private let titleLabel = UILabel()
    private let keyLabel = UILabel()
    private let requestIdLabel = UILabel()
    private let statusLabel = UILabel()
    private let submitButton = UIButton(type: .system)

    private lazy var containerView = UIView()

    override func layoutBody() -> UIView {
        let inner = SBALinearLayout.vStack(
            spacing: Constants.stackSpacing,
            alignment: .left
        ) {
            self.titleLabel
            self.keyLabel
            self.requestIdLabel
            self.statusLabel
            
            SBALinearLayout.hStack {
                self.submitButton
            }
        }
        
        return SBALinearLayout.zStack { container in
            container.add(self.containerView)
            container.add(inner, offset: .init(
                top: Constants.padding,
                left: Constants.padding,
                bottom: Constants.padding,
                right: Constants.padding
            ))
        }
    }
    
    // MARK: - View Lifecycle
    

    override func setupViews() {
        super.setupViews()

        // Stamp the runtime class name onto the view so users running QuickStart can immediately
        // discover which source file is the reference (e.g. "SampleChallengeView.swift").
        // When a host registers a subclass, the title automatically reflects the host's class name.
        self.titleLabel.text = "\(String(describing: type(of: self))).swift"
        self.titleLabel.numberOfLines = 0

        [self.keyLabel, self.requestIdLabel, self.statusLabel].forEach { $0.numberOfLines = 0 }

        self.submitButton.setTitle("Submit", for: .normal)
    }

    override func setupLayouts() {
        super.setupLayouts()
    }

    override func setupStyles() {
        super.setupStyles()

        // Container
        self.containerView.backgroundColor = Constants.backgroundColor
        self.containerView.layer.cornerRadius = Constants.cornerRadius

        // Title — monospaced + secondary color so it reads as a file pointer / hint.
        self.titleLabel.textColor = .secondaryLabel
        self.titleLabel.font = .monospacedSystemFont(ofSize: 11, weight: .medium)

        // Labels
        [self.keyLabel, self.requestIdLabel, self.statusLabel].forEach {
            $0.textColor = Constants.labelTextColor
            $0.font = .systemFont(ofSize: 14)
        }

        // Button
        self.submitButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        self.submitButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        self.submitButton.backgroundColor = Constants.buttonColor
        self.submitButton.layer.cornerRadius = Constants.buttonCornerRadius
        self.submitButton.contentEdgeInsets = Constants.buttonContentInsets
    }
    
    override func setupActions() {
        super.setupActions()
        
        self.submitButton.removeTarget(nil, action: nil, for: .touchUpInside)
        self.submitButton.addTarget(self, action: #selector(self.onTapSubmit), for: .touchUpInside)
    }

    // MARK: - Configuration

    override func configure(with challenge: SBAChallenge?, channelUrl: String?) {
        super.configure(with: challenge, channelUrl: channelUrl)

        // Push payload into subviews. Lifecycle hooks above (setupViews/Layouts/Styles) have
        // already been re-invoked by `super.configure(...)`, so the view tree is ready.
        self.keyLabel.text = "key: \(challenge?.key ?? "-")"
        self.requestIdLabel.text = "request_id: \(challenge?.requestId ?? "-")"
        self.statusLabel.text = "status: \(challenge?.status.rawValue ?? "-")"
    }

    // MARK: - Actions

    @objc
    private func onTapSubmit() {
        // Sample sends an empty payload — real forms attach the customer's auth data here
        // as `[String: any Encodable]` (e.g. ["authorization_code": "abc"]).
        self.submitButton.isEnabled = false
        self.submitButton.setTitle("Sending...", for: .normal)

        self.sendEvent(action: .submit, data: [:]) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.submitButton.isEnabled = true
                self.submitButton.setTitle("Submit", for: .normal)

                if case .failure(let error) = result {
                    self.statusLabel.text = "transport error: \(error.localizedDescription)"
                }
            }
        }
    }
}
#endif // INTERNAL_SAMPLE_CHALLENGE
