//
//  TabBarViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//
// swiftlint: disable trailing_comma

import UIKit

class TabBarViewController: UITabBarController {
	// MARK: - Private Properties

	private let tabBarItems: [TabBarItem] = [.home, .swap, .invest, .borrow, .activity]
	private var tabBarItemViewControllers = [UIViewController]()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
		setupTabBarItems()
	}

	// MARK: - Private Functions

	private func setupView() {
		tabBar.backgroundColor = .Pino.secondaryBackground

		let appearance = UITabBarAppearance()
		// Tab bar background color
		appearance.backgroundColor = .Pino.secondaryBackground
		// Tab title color
		appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
			.foregroundColor: UIColor.Pino.primary,
			.font: UIFont.PinoStyle.SemiboldCaption2!,
		]
		appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
			.foregroundColor: UIColor.Pino.primary,
			.font: UIFont.PinoStyle.mediumCaption2!,
		]
		// Tab icon color
		appearance.stackedLayoutAppearance.normal.iconColor = .Pino.primary
		appearance.stackedLayoutAppearance.selected.iconColor = .Pino.primary

		tabBar.standardAppearance = appearance
	}

	private func setupTabBarItems() {
		for tabItem in tabBarItems {
			let tabBarItemViewController = tabItem.viewController
			tabBarItemViewController.tabBarItem = UITabBarItem(
				title: tabItem.title,
				image: UIImage(named: tabItem.image),
				selectedImage: UIImage(named: tabItem.selectedImage)
			)
			tabBarItemViewControllers.append(tabBarItemViewController)
		}

		viewControllers = tabBarItemViewControllers
	}
}
