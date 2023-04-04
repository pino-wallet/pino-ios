//
//  LockMethodModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

struct LockMethodModel {
	public let title: String
	public let type: type
}

extension LockMethodModel {
	public enum type: String {
		case face_id = "face_id"
		case passcode = "passcode"
	}
}
