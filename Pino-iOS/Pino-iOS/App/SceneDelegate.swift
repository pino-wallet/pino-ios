//
//  SceneDelegate.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	// MARK: - Private Properties

	private var lockScreenView: PrivacyLockView?
	private var authManager: AuthenticationLockManager!
	private var appIsLocked = false
	private var showPrivateScreen = true
	private var cancellables = Set<AnyCancellable>()

	private var isUserLoggedIn: Bool {
		let isUserLoggedInBool: Bool? = UserDefaultsManager.isUserLoggedIn.getValue()
		return isUserLoggedInBool ?? false
	}

	private var lockScreenVC: LockScreenViewController?
	private var topPresentedVC: UIViewController? {
		if var topVC = window?.rootViewController {
			while let presentedVC = topVC.presentedViewController {
				topVC = presentedVC
			}
			return topVC
		}
		return nil
	}

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
		UserDefaultsManager.isDevModeUser.registerDefault(value: false)
		UserDefaultsManager.hasShowNotifPageUser.registerDefault(value: false)
		UserDefaultsManager.biometricCount.registerDefault(value: 0)
		UserDefaultsManager.securityModesUser
			.registerDefault(value: [SecurityOptionModel.LockType.immediately.rawValue])
		let emptyRecentAddressList: [RecentAddressModel] = []
		UserDefaultsManager.recentAddUser
			.registerDefault(value: emptyRecentAddressList)

		if isUserLoggedIn {
			window?.rootViewController = TabBarViewController()
			modifyAppLock()
		} else {
			let navigationController = CustomNavigationController(rootViewController: IntroViewController())
			window?.rootViewController = navigationController
		}

		window?.makeKeyAndVisible()
		checkForNewForcedUpdate()

		// Disable animations in test mode to speed up tests
		disableAllAnimationsInTestMode()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see
		// `application:didDiscardSceneSessions` instead).
		print("scene: sceneDidDisconnect: \(appIsLocked)")
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
		print("scene: sceneDidBecomeActive: \(appIsLocked)")
		hideLockView()
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
		print("scene: sceneWillResignActive: \(appIsLocked)")
		showLockView()
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
		print("scene: sceneWillEnterForeground: \(appIsLocked)")
		showLockView()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
		CoreDataStack.pinoSharedStack.saveContext()
		modifyAppLock()
		if let currentLockVC = topPresentedVC as? UnlockAppViewController {
			currentLockVC.dismiss(animated: false)
		}
		dismissLockScreenVC()

		print("scene: sceneDidEnterBackground: \(appIsLocked)")
	}

	// MARK: - Private Methods

	private func modifyAppLock() {
		let securityModes: [String] = UserDefaultsManager.securityModesUser.getValue() ?? []
		if securityModes.contains(SecurityOptionModel.LockType.immediately.rawValue) {
			appIsLocked = true
		}
	}

	private func hideLockView() {
		guard isUserLoggedIn == true else { return }

		if showPrivateScreen && !appIsLocked {
			dismissLockScreenVC()
		}
	}

	private func showLockView() {
		guard isUserLoggedIn == true, let window = window, showPrivateScreen && lockScreenVC == nil else { return }
		let rootVC = window.rootViewController
		lockScreenVC = LockScreenViewController(onSuccessLoginClosure: {
			self.appIsLocked = false
			self.dismissLockScreenVC()
		}, shouldUnlockApp: appIsLocked)
		lockScreenVC?.modalPresentationStyle = .overFullScreen

		if topPresentedVC != nil {
			topPresentedVC?.present(lockScreenVC!, animated: false)
		} else {
			rootVC?.present(lockScreenVC!, animated: false)
		}
	}

	private func dismissLockScreenVC() {
		lockScreenVC?.dismissSelf()
		lockScreenVC = nil
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

	private func checkForNewForcedUpdate() {
		let buildNumberInfoAPIClient = BuildNumberInfoAPIClient()

		buildNumberInfoAPIClient.getCurrentAppBuildNumberInfo().sink { completed in
			switch completed {
			case .finished:
				print("tokens received successfully")
			case let .failure(error):
				print("Failed to fetch update details:\(error)")
				Toast.default(title: "Failed to check for new updates", style: .error).show(haptic: .warning)
			}
		} receiveValue: { buildNumberInfo in
			guard let currentBuildNumberString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
			      let currentBuildNumberInt = Int(currentBuildNumberString) else {
				return
			}
			if currentBuildNumberInt < buildNumberInfo.version && buildNumberInfo.force {
				if !UIDevice.current.isSimulator {
					self.showForcedUpdateAlert()
				}
			}
		}.store(in: &cancellables)
	}

	private func showForcedUpdateAlert() {
		let forcedUpdateAlertVC = AlertHelper.alertController(
			title: "Major Update Required",
			message: "A major update has been detected, please update app to the latest version.",
			actions: [.gotIt(handler: { _ in
				exit(0)
			})]
		)
		window?.rootViewController?.present(forcedUpdateAlertVC, animated: true)
	}
}
