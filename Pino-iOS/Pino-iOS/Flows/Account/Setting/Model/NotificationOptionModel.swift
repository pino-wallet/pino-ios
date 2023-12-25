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
	public var isSelected: Bool
    public var description: String?
}

extension NotificationOptionModel {
	public enum NotificationOption: String {
		case wallet_activity
		case liquidation_notice
		case pino_update
		case allow_notification
	}
}
