//
//  AddCustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

import BigInt
import Foundation

class AddCustomAssetViewModel {
	// MARK: - Public Enums

	public enum ContractValidationStatus: Equatable {
		case clear
		case pasteFromClipboard(String)
		case pending
		case error(CustomAssetValidationError)
		case success
	}

	#warning("These values are for testing and should be changed")
	public enum ValidateTextFieldDelay: Double {
		case small = 0.2
		case none = 0.0
	}

	public enum CustomAssetValidationError: Error {
		case notValid
		case networkError
		case notValidFromServer
		case unavailableNode
		case unknownError
		case notValidSmartContractAddress
		case alreadyAdded

		public var description: String {
			switch self {
			case .notValid:
				return "Address is not an ETH valid address"
			case .networkError:
				return "No internet connection, try again later"
			case .notValidFromServer:
				return "Custom asset is not valid"
			case .unavailableNode:
				return "Cant access to the network, try again later"
			case .unknownError:
				return "Unknown error happend, try again later"
			case .notValidSmartContractAddress:
				return "Address is not a valid smart contract address"
			case .alreadyAdded:
				return "Token is already added"
			}
		}
	}

	// MARK: - Closures

	public var changeViewStatusClosure: ((ContractValidationStatus) -> Void)!

	// MARK: - Public Properties

	public var customAssetVM: CustomAssetViewModel?

	public let addCustomAssetButtonTitle = "Add"
	public let addcustomAssetPageTitle = "Add custom asset"
	public let addCustomAssetPageBackButtonIcon = "dissmiss"
	public let addCustomAssetTextfieldPlaceholder = "Enter contract address"
	public let addCustomAssetTextfieldError = "This is an error!"
	public let addCustomAssetTextfieldIcon = "qr_code_scanner"

	public var customAssetNameInfo: CustomAssetInfoViewModel
	public var customAssetUserBalanceInfo: CustomAssetInfoViewModel
	public var customAssetSymbolInfo: CustomAssetInfoViewModel
	public var customAssetDecimalInfo: CustomAssetInfoViewModel
	public var userAddress: String
	public var userTokens: [Detail]

	// MARK: - Private Properties

	private var getCustomAssetInfoRequestWork: DispatchWorkItem!
	private var readNodeContractKey = "0"
	private var userAddressStaticCode = "0x"

	private let coredataManager = CoreDataManager()

	// MARK: - Initializers

	init(useraddress: String, userTokens: [Detail]) {
		self.userAddress = useraddress
		self.userTokens = userTokens
		#warning("this aletsTexts are for testing")
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
			.customAssetSymbolInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(title: "Symbol", alertText: "Sample Text"))
		self
			.customAssetDecimalInfo =
			CustomAssetInfoViewModel(customAssetInfo: CustomAssetInfoModel(
				title: "Decimal",
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

	public func validateContractAddressBeforeRequest(textFieldText: String, delay: ValidateTextFieldDelay) {
		if textFieldText.isEmpty {
			changeViewStatusClosure(.clear)
			return
		}

		if textFieldText.validateETHContractAddress() {
			let lowercasedTextFieldText = textFieldText.lowercased()
			let foundToken = userTokens.first(where: { $0.id.lowercased() == lowercasedTextFieldText })
			if foundToken != nil {
				changeViewStatusClosure(.error(.alreadyAdded))
				return
			} else {
				changeViewStatusClosure(.pending)
				DispatchQueue.main.asyncAfter(deadline: .now() + delay.rawValue) {
					do {
						let _ = try Web3Core.shared.getCustomAssetInfo(contractAddress: textFieldText)
							.done { [weak self] assetInfo in
								if let name = assetInfo[.name]?.description,
								   let symbol = assetInfo[.symbol]?.description,
								   let balance = assetInfo[.balance]?.description,
								   let decimal = assetInfo[.decimal]?.description {
									self?.customAssetVM = CustomAssetViewModel(customAsset: CustomAssetModel(
										id: textFieldText.trimmingCharacters(in: .whitespaces),
										name: name,
										symbol: symbol,
										balance: balance,
										decimal: decimal
									))
									self?.changeViewStatusClosure(.success)
								}
							}
					} catch {
						self.changeViewStatusClosure(.error(.notValid))
					}
				}
			}
		} else {
			changeViewStatusClosure(.error(.notValid))
		}
	}

	public func saveCustomTokenToCoredata() -> CustomAsset? {
		guard let customAssetVM else { return nil }
		if coredataManager.getAllCustomAssets().contains(where: { $0.id == customAssetVM.contractAddress }) {
			return nil
		} else {
			let customAssetModel = coredataManager.addNewCustomAsset(
				id: customAssetVM.contractAddress,
				symbol: customAssetVM.symbol,
				name: customAssetVM.name,
				decimal: customAssetVM.decimal
			)
			return customAssetModel
		}
	}

}
