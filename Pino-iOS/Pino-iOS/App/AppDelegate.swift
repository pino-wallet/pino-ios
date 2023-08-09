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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
//            CoreDataManager().addNewSwapActivity(activityModel: ActivitySwapModel(txHash: "0x6ecf5d19f98411b6039cbb0380f149a017e3cde810541c39965ecfa6744e0348", type: "swap", detail: SwapActivityDetails(fromToken: ActivityTokenModel(amount: "151515", tokenID: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"), toToken: ActivityTokenModel(amount: "41451", tokenID: "0x0000000000000000000000000000000000000000"), activityProtocol: "Uniswap"), fromAddress: "0x938d52c887cE1352868793821D687f4d775a18a9", toAddress: "0x938d52c887cE1352868793821D687f4d775a18a9", blockTime: ActivityHelper().getServerFormattedStringDate(date: Date()), gasUsed: "11515", gasPrice: "511616"), accountAddress: "0x938d52c887cE1352868793821D687f4d775a18a9")
//            PendingActivitiesManager.shared.startActivityPendingRequests()
//        })
        
//        print("heh", PendingActivitiesManager.shared.pendingActivitiesList)
//        let ts = CoreDataManager().getAllActivities()[0] as! CDSwapActivity
//        print("hehe", ts.details.from_token.tokenId)
//        let ts = CoreDataManager().getAllActivities()[0] as! CDTransferActivity
//        print("heh", ts.gasPrice, ts.gasUsed, ts.details.amount )
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
