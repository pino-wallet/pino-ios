//
//  AddCustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

import Foundation

class AddCustomAssetViewModel {
	// MARK: - Public Enums

	public enum validateTextFieldDelay: Double {
		case small = 0.5
		case none = 0.0
	}

	public enum failedToValidateCustomAssetStatus: String {
		case isEmpty
		case notValid = "Address is not an ETH valid address"
		case networkError = "No internet connection, retrying..."
		case notValidFromServer = "Custom asset not found"
	}

	// MARK: - Closures

	public var setupPasteFromClipboardViewClosure: ((String) -> Void)!
	public var setupCustomAssetInfoViewClosure: (() -> Void)!
	public var failedToValidateContractAddressClosure: ((failedToValidateCustomAssetStatus) -> Void)!
	public var enableContractAddressTextfieldPendingClosure: (() -> Void)!

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

	// MARK: - Private Properties

	private var getCustomAssetInfoRequestWork: DispatchWorkItem!

	// MARK: - Initializers

	init() {
		self.customAsset = CustomAssetViewModel(
			customAsset:
			CustomAssetModel(
				name: "",
				icon: "",
				balance: "",
				website: "",
				contractAddress: ""
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

	public func validateContractAddressFromTextField(textFieldText: String, delay: validateTextFieldDelay) {
		if textFieldText.isEmpty {
			failedToValidateContractAddressClosure(.isEmpty)
			cancelGetCustomAssetRequestWork()
			return
		}

		if textFieldText.validateETHContractAddress() {
			enableContractAddressTextfieldPendingClosure()
			cancelGetCustomAssetRequestWork()
			getCustomAssetInfoRequestWork = DispatchWorkItem(block: { [weak self] in
				self?.getCustomAssetInfo(contractAddress: textFieldText)
			})
			DispatchQueue.main.asyncAfter(deadline: .now() + delay.rawValue + 2, execute: getCustomAssetInfoRequestWork)
		} else {
			failedToValidateContractAddressClosure(.notValid)
			cancelGetCustomAssetRequestWork()
		}
	}

	// MARK: - Private Methods

	private func getCustomAssetInfo(contractAddress: String) {
		customAsset = CustomAssetViewModel(customAsset: CustomAssetModel(
			name: "USDC",
			icon: "USDC",
			balance: "201.2",
			website: "www.USDC.com",
			contractAddress: "0x4108A1698EDB3d3E66aAD93E030dbF28Ea5ABB11"
		))
		setupCustomAssetInfoViewClosure()
	}

	private func cancelGetCustomAssetRequestWork() {
		if let getCustomAssetInfoRequestWork {
			getCustomAssetInfoRequestWork.cancel()
		}
	}
}
