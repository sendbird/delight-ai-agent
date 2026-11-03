//
//  SceneDelegate.swift
//  QuickStart
//

import UIKit

/// Lets the app delegate decide what the scene's window shows.
///
/// `QuickStart/Info.plist` is shared by QuickStart and the demo apps that reuse its sources,
/// so each app delegate adopts this protocol instead of each app owning its own scene delegate.
protocol SceneWindowConfiguring: AnyObject {
    func configure(window: UIWindow)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Lifecycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        guard let configurator = UIApplication.shared.delegate as? SceneWindowConfiguring else {
            assertionFailure("[SceneDelegate] App delegate must adopt SceneWindowConfiguring")
            window.makeKeyAndVisible()
            return
        }
        configurator.configure(window: window)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // With a scene manifest, UIKit no longer calls `applicationDidBecomeActive(_:)`.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
