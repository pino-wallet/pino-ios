//
//  TabBarViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class TabBarViewController: UITabBarController {
	// MARK: - Private Properties

	private let tabBarItems: [TabBarItem] = [.home, .swap, .invest, .borrow, .activity]
	private var tabBarItemViewControllers = [UIViewController]()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupTabBarItems()
	}

	// MARK: - Private Functions

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

extension TabBarViewController: UITabBarControllerDelegate {
	// MARK: - Delegate Methods

	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
