//
//  SceneDelegate.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see
		// `application:configurationForConnectingSceneSession` instead).
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		UserDefaults.standard.register(defaults: ["hasShownNotifPage": false])
		UserDefaults.standard.register(defaults: ["isInDevMode": false])
		if UserDefaults.standard.bool(forKey: "isLogin") {
			window?.rootViewController = TabBarViewController()
		} else {
			let navigationController = CustomNavigationController(rootViewController: IntroViewController())
			window?.rootViewController = navigationController
		}
		UserDefaults.standard.register(defaults: [
			"hasSeenSwapTut": false,
			"hasSeenInvestTut": false,
			"hasSeenBorrowTut": false,
		])
		window?.makeKeyAndVisible()

		// Disable animations in test mode to speed up tests
		disableAllAnimationsInTestMode()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see
		// `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
		CoreDataStack.pinoSharedStack.saveContext()
	}

	private func disableAllAnimationsInTestMode() {
		if ProcessInfo.processInfo.arguments.contains(LaunchArguments.isRunningUITests.rawValue) {
			if let scene = UIApplication.shared.connectedScenes.first,
			   let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
			   let window = windowSceneDelegate.window {
				// Disable Core Animations
				window?.layer.speed = 0
			}

			// Disable UIView animations
			UIView.setAnimationsEnabled(false)
		}
	}
}
