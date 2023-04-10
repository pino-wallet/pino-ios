//
//  NotificationViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import Foundation

class NotificationsViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Notifications"
	public let allowNotficationsTitle = "Allow notification"
	public let notificationOptionsSectionTitle = "Options"

	#warning("this tooltip texts are for testing and should be changed")
	public let notificationOptions = [
		NotificationOptionModel(
			title: "Wallet activity",
			type: .wallet_activity,
			tooltipText: "this is wallet activity",
			isSelected: true
		),
		NotificationOptionModel(
			title: "Investment performance",
			type: .investment_performance,
			tooltipText: "this is investment performance",
			isSelected: false
		),
		NotificationOptionModel(
			title: "Health score",
			type: .health_score,
			tooltipText: "this is wallet health score",
			isSelected: true
		),
		NotificationOptionModel(
			title: "Uniswap price range",
			type: .uniswap_price_range,
			tooltipText: "this is uniswap price range",
			isSelected: false
		),
		NotificationOptionModel(
			title: "Pino update",
			type: .pino_update,
			tooltipText: "this is pino update",
			isSelected: true
		),
	]
}
