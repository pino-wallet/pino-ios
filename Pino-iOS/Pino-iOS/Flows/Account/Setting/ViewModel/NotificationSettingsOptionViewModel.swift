//
//  NotificationOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

struct NotificationSettingsOptionViewModel: CustomSwitchOptionVM {
	// MARK: - Public Properties

	public var notificationOption: NotificationOptionModel

	public var title: String {
		notificationOption.title
	}

	public var description: String? {
		notificationOption.description
	}

	public var isSelected: Bool {
		notificationOption.isSelected
	}

	public var type: String {
		notificationOption.type.rawValue
	}
}
