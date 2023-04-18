//
//  LockTypeModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/3/23.
//

struct SecurityOptionModel {
	public let title: String
	public let type: LockType
	public let isSelected: Bool
}

extension SecurityOptionModel {
	public enum LockType: String {
		case on_transactions
		case immediately
	}
}
