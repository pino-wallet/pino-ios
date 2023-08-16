//
//  AppDelegate.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import CoreData
import Kingfisher
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		// Override point for customization after application launch.
		setupNavigationBarCustomBackButton()
		setupLightKeyboardForTextFields()
		setCacheLimitForKingFisherImages()
		setupNotifications()
		//        CoreDataManager().addNewTransferActivity(activityModel: ActivityTransferModel(txHash: "0xd0d55cbb774afc61e61df5feca715ba5139955cf1e2c0e2804e457b8b4257169", type: "transfer", detail: TransferActivityDetail(amount: "315151", tokenID: "aagagwa", from: "0x316110a635d150e2D6a1CC8148268bb482146a05", to: "0x7840fD13A8237C08A258DDd982D369acA81388A3"), fromAddress: "0x316110a635d150e2D6a1CC8148268bb482146a05", toAddress: "0x7840fD13A8237C08A258DDd982D369acA81388A3", blockTime: ActivityHelper().getServerFormattedStringDate(date: Date()), gasUsed: "44444", gasPrice: "1"), accountAddress: "0x316110a635d150e2D6a1CC8148268bb482146a05")
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after
		// application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
}

extension AppDelegate {
	// MARK: - Custom Navigation Bar

	private func setupNavigationBarCustomBackButton() {
		let backImage = UIImage(systemName: "arrow.left")
		let navigationBar = UINavigationBar.appearance()
		navigationBar.backIndicatorImage = backImage
		navigationBar.backIndicatorTransitionMaskImage = backImage
		navigationBar.tintColor = .Pino.label
		navigationBar.overrideUserInterfaceStyle = .light
		navigationBar.shadowImage = UIImage()
	}

	private func setupLightKeyboardForTextFields() {
		UITextField.appearance().keyboardAppearance = .light
	}

	private func setCacheLimitForKingFisherImages() {
		ImageCache.default.diskStorage.config.expiration = .seconds(259_200)
	}

	private func setupNotifications() {
		let notificationsCenter = NotificationCenter.default
		notificationsCenter.addObserver(
			self,
			selector: #selector(didMoveToBackground),
			name: UIApplication.didEnterBackgroundNotification,
			object: nil
		)
		notificationsCenter.addObserver(
			self,
			selector: #selector(didBecomeActive),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}

	@objc
	private func didMoveToBackground() {
		PendingActivitiesManager.shared.stopActivityPendingRequests()
	}

	@objc
	private func didBecomeActive() {
		let coreDataManager = CoreDataManager()
		if !coreDataManager.getAllActivities().isEmpty {
			PendingActivitiesManager.shared.startActivityPendingRequests()
		}
	}
}
