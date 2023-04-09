//
//  PaymentMethodOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/9/23.
//

import Foundation

public struct PaymentMethodOptionViewModel {
	// MARK: - Public Properties

	public var paymentMethodOption: PaymentMethodOptionModel

	public var title: String {
		paymentMethodOption.title
	}

	public var description: String {
		paymentMethodOption.description
	}

	public var url: String {
		paymentMethodOption.url
	}

	public var iconName: String {
		paymentMethodOption.iconName
	}

	public var rightIconInfoName: String {
		paymentMethodOption.rightInfoIconName
	}
}
