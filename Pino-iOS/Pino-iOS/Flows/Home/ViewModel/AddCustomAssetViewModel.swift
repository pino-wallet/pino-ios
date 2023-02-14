//
//  AddCustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

class AddCustomAssetViewModel {
	#warning("Those values are for testing and should be changed")

	// MARK: - Private Properties

	private var originalCustomAsset: CustomAssetModel!

	// MARK: - Public Properties

	public var customAsset: CustomAssetModel! {
		originalCustomAsset
	}

	public let addCustomAssetButtonTitle = "Add"
	public let addcustomAssetPageTitle = "Add custom asset"
	public let addCustomAssetPageBackButtonIcon = "arrow_left"
	public let addCustomAssetTextfieldPlaceholder = "Enter contract address"
	public let addCustomAssetTextfieldError = "This is an error!"
	public let addCustomAssetTextfieldIcon = "qr_code_scanner"

	public let customAssetNameItem = CustomAssetItemModel(title: "Name", tooltipText: "Some text")
	public let customAssetUserBalanceItem = CustomAssetItemModel(title: "Your balance", tooltipText: "Some text")
	public let customAssetWebsiteItem = CustomAssetItemModel(title: "Website", tooltipText: "Some text")
	public let customAssetContractAddressItem = CustomAssetItemModel(
		title: "Contract address",
		tooltipText: "Some text"
	)

	// MARK: - Initializers

	init() {
		setCustomAsset()
	}

	// MARK: - Private Methods

	private func setCustomAsset() {
		originalCustomAsset = CustomAssetModel(
			name: "USDC",
			icon: "USDC",
			balance: "201.2",
			website: "www.USDC.com",
			contractAddress: "0x4108A1698EDB3d3E66aAD93E030dbF28Ea5ABB11"
		)
	}
}
