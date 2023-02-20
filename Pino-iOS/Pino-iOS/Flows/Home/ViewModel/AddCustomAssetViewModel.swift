//
//  AddCustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

import Foundation

class AddCustomAssetViewModel {
	// MARK: - Public Enums

	public enum ResponseStatus {
		case clear
		case pasteFromClipboard(String)
		case pending
		case error(FailedToValidateCustomAssetStatus)
		case success
	}

	#warning("These values are for testing and should be changed")
	public enum ValidateTextFieldDelay: Double {
		case small = 0.5
		case none = 0.0
	}

	public enum FailedToValidateCustomAssetStatus: Error {
		case notValid
		case networkError
		case notValidFromServer

		public var description: String {
			switch self {
			case .notValid:
				return "Address is not an ETH valid address"
			case .networkError:
				return "No internet connection, retrying..."
			case .notValidFromServer:
				return "Custom asset not found"
			}
		}
	}

	// MARK: - Closures

	public var changeViewStatusClosure: ((ResponseStatus) -> Void)!

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
			changeViewStatusClosure(.pasteFromClipboard(clipboardText))
		}
	}

	public func validateContractAddressFromTextField(textFieldText: String, delay: ValidateTextFieldDelay) {
		if textFieldText.isEmpty {
			changeViewStatusClosure(.clear)
			cancelGetCustomAssetRequestWork()
			return
		}

		if textFieldText.validateETHContractAddress() {
			changeViewStatusClosure(.pending)
			cancelGetCustomAssetRequestWork()
			getCustomAssetInfoRequestWork = DispatchWorkItem(block: { [weak self] in
				self?.getCustomAssetInfo(contractAddress: textFieldText)
			})
			#warning("This 2 second delay is for testing and should be removed")
			DispatchQueue.main.asyncAfter(deadline: .now() + delay.rawValue + 2, execute: getCustomAssetInfoRequestWork)
		} else {
			changeViewStatusClosure(.error(.notValid))
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
		changeViewStatusClosure(.success)
	}

	private func cancelGetCustomAssetRequestWork() {
		if let getCustomAssetInfoRequestWork {
			getCustomAssetInfoRequestWork.cancel()
		}
	}
}
