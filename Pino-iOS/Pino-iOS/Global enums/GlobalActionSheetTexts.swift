//
//  GlobalActionSheetTexts.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/7/24.
//

import Foundation

public enum GlobalActionSheetTexts {
	case networkFee

	public var title: String {
		switch self {
		case .networkFee:
			return "Network fee"
		}
	}

	public var description: String {
		switch self {
		case .networkFee:
			return "This is a network fee charged by Ethereum for processing your transaction. Pino does not receive any part of this fee."
		}
	}
}
