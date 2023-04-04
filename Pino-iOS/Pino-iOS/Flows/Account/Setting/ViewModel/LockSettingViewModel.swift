//
//  SecurityLockTypeViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

struct LockSettingViewModel: CustomSwitchCollectionCellVM {
	// MARK: - Public Properties

	public let lockSettingOption: LockSettingModel

	public var title: String {
		lockSettingOption.title
	}

	public var isSelected: Bool {
		lockSettingOption.isSelected
	}

	public var tooltipText: String! {
		nil
	}

	public var type: String {
		lockSettingOption.type.rawValue
	}
}
