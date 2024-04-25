//
//  EditAccountOptionModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//


struct EditAccountOptionModel {
	public let title: String
	public let type: EditAccountOptionType
	public let rightIconName: String
}

extension EditAccountOptionModel {
	public enum EditAccountOptionType {
		case name
		case private_key
	}
}
