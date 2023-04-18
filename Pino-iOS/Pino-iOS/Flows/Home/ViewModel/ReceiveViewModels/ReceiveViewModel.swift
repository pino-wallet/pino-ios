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
	public let walletOwnerNameDescriptionText = "wallet"

	public let paymentMethodOptions = [PaymentMethodOptionModel(
		title: "MoonPay",
		description: "Buy crypto with fiat",
		iconName: "moon_pay",
		url: "https://www.moonpay.com/buy",
		rightInfoIconName: "right_arrow_green3"
	)]
}
