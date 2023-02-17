//
//  AddCustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

class AddCustomAssetViewModel {
	// MARK: - Closures

	public var setupPasteFromClipboardViewClosure: ((String) -> Void)!

	#warning("Those values are for testing and should be changed")

	// MARK: - Public Properties

	public var customAsset: CustomAssetViewModel

	public let addCustomAssetButtonTitle = "Add"
	public let addcustomAssetPageTitle = "Add custom asset"
	public let addCustomAssetPageBackButtonIcon = "dissmiss"
	public let addCustomAssetTextfieldPlaceholder = "Enter contract address"
	public let addCustomAssetTextfieldError = "This is an error!"
	public let addCustomAssetTextfieldIcon = "qr_code_scanner"

	public var customAssetNameInfo: CustomAssetInfoViewModel
	public var customAssetUserBalanceInfo: CustomAssetInfoViewModel
	public var customAssetWebsiteInfo: CustomAssetInfoViewModel
	public var customAssetContractAddressInfo: CustomAssetInfoViewModel

	// MARK: - Initializers

	init() {
		self.customAsset = CustomAssetViewModel(
			customAsset:
			CustomAssetModel(
				name: "USDC",
				icon: "USDC",
				balance: "201.2",
				website: "www.USDC.com",
				contractAddress: "0x4108A1698EDB3d3E66aAD93E030dbF28Ea5ABB11"
			)
		)
		self
			.customAssetNameInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(title: "Name", alertText: "Sample Text"))
		self
			.customAssetUserBalanceInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(
				title: "Your balance",
				alertText: "Sample Text"
			))
		self
			.customAssetWebsiteInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(title: "Website", alertText: "Sample Text"))
		self
			.customAssetContractAddressInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(
				title: "Contract address",
				alertText: "Sample Text"
			))
	}

	// MARK: - Public Methods

	public func validateContractAddressFromClipboard(clipboardText: String) {
		if clipboardText.isEmpty {
			return
		}
		if clipboardText.validateETHContractAddress() {
			setupPasteFromClipboardViewClosure?(clipboardText)
		}
	}
}
