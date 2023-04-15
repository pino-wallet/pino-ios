//
//  NotificationOptionModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import Foundation

struct NotificationOptionModel {
	public var title: String
	public var type: NotificationOption
	public var tooltipText: String?
	public var isSelected: Bool
}

extension NotificationOptionModel {
	public enum NotificationOption: String {
		case wallet_activity
		case investment_performance
		case health_score
		case uniswap_price_range
		case pino_update
		case allow_notification
	}
}
