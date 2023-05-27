//
//  AddNewWalletOption.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

struct AddNewAccountOptionModel {
	// MARK: - Public Properties

	public let title: String
	public let descrption: String
	public let iconName: String
	public let type: type
	public var isLoading: Bool
}

extension AddNewAccountOptionModel {
	public enum type {
		case Create
		case Import
	}
}
