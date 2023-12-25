//
//  SecurityLockTypeViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

struct SecurityOptionViewModel: CustomSwitchOptionVM {
	// MARK: - Public Properties

	public let lockSettingOption: SecurityOptionModel

	public var title: String {
		lockSettingOption.title
	}

	public var isSelected: Bool {
		lockSettingOption.isSelected
	}
    
    public var description: String? {
        lockSettingOption.description
    }

	public var type: String {
		lockSettingOption.type.rawValue
	}
}
