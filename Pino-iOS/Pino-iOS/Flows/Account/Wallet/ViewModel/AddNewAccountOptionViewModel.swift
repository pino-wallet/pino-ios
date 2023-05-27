//
//  CreateImportOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

struct AddNewAccountOptionViewModel {
	// MARK: - Public Properties

	public let addNewAccountOption: AddNewAccountOptionModel

	public var title: String {
		addNewAccountOption.title
	}

	public var description: String {
		addNewAccountOption.descrption
	}

	public var iconName: String {
		addNewAccountOption.iconName
	}

	public var page: AddNewAccountOptionModel.type {
		addNewAccountOption.type
	}

	public var isLoading: Bool {
		addNewAccountOption.isLoading
	}
}
