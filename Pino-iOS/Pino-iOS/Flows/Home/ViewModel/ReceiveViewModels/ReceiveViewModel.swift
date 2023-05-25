//
//  ReceiveViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

class ReceiveViewModel {
	// MARK: - Public Properties

	public let shareAddressButtonText = "Share"
	public let copyAddressButtonText = "Copy"
	public let copiedToastViewText = "Copied!"
	public let copyAddressButtonIconName = "copy"
	public let shareAddressButtonIconName = "share"
	public let navigationDismissButtonIconName = "arrow_left"
	public let navigationTitleText = "Receive"
	public let accountOwnerNameDescriptionText = "account"

	public let paymentMethodOptions = [PaymentMethodOptionModel(
		title: "MoonPay",
		description: "Buy crypto with fiat",
		iconName: "moon_pay",
		url: "https://www.moonpay.com/buy",
		rightInfoIconName: "right_arrow_green3"
	)]

	public var accountAddress: String {
		accountInfo.address
	}

	public var accountName: String {
		accountInfo.name
	}

	// MARK: - Private Properties

	private let accountInfo: AccountInfoViewModel

	init(accountInfo: AccountInfoViewModel) {
		self.accountInfo = accountInfo
	}
}
