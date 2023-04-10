//
//  NotificationOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

struct NotificationOptionViewModel: CustomSwitchCollectionCellVM {
	// MARK: - Public Properties

	public var notificationOption: NotificationOptionModel

	public var title: String {
		notificationOption.title
	}

	public var isSelected: Bool {
		notificationOption.isSelected
	}

	public var tooltipText: String! {
		notificationOption.tooltipText
	}

	public var type: String {
		notificationOption.type.rawValue
	}
}
