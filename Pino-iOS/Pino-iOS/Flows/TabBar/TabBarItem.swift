//
//  TabBarItem.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

struct TabBarItem {
	// MARK: - Public Properties

	public let title: String
	public let image: String
	public let selectedImage: String
	public let viewController: UIViewController
}

extension TabBarItem {
	// MARK: - Custom Tab Items

	public static let home = TabBarItem(
		title: "Home",
		image: "home_tab",
		selectedImage: "home_tab_fill",
		viewController: UINavigationController(rootViewController: HomepageViewController())
	)

	public static let swap = TabBarItem(
		title: "Swap",
		image: "swap_tab",
		selectedImage: "swap_tab_fill",
		viewController: SwapViewController()
	)

	public static let invest = TabBarItem(
		title: "Invest",
		image: "invest_tab",
		selectedImage: "invest_tab_fill",
		viewController: InvestViewController()
	)

	public static let borrow = TabBarItem(
		title: "Borrow",
		image: "borrow_tab",
		selectedImage: "borrow_tab_fill",
		viewController: BorrowViewController()
	)

	public static let activity = TabBarItem(
		title: "Activity",
		image: "activity_tab",
		selectedImage: "activity_tab_fill",
		viewController: ActivityViewController()
	)
}
