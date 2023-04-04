//
//  LockMethodModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

struct LockMethodModel {
	public let title: String
	public let type: LockMethodType
}

extension LockMethodModel {
	public enum LockMethodType: String {
		case face_id
		case passcode
	}
}
