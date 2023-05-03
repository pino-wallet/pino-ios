//
//  EditAccountOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/26/23.
//

struct EditAccountOptionViewModel {
	// MARK: - Public Properties

	public let editAccountOption: EditAccountOptionModel

	public var title: String {
		editAccountOption.title
	}

	public var rightIconName: String {
		editAccountOption.rightIconName
	}
}
