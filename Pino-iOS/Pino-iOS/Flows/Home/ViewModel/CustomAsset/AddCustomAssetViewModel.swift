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

	public enum CustomAssetValidationError: Error {
		case notValid
		case networkError
		case notValidFromServer
		case unavailableNode
		case unknownError
		case alreadyAdded

		public var description: String {
			switch self {
			case .notValid:
				return "Invalid address"
			case .networkError:
				return "No connection"
			case .notValidFromServer:
				return "Invalid asset"
			case .unavailableNode:
				return "Unavailable node"
			case .unknownError:
				return "Unknown error"
			case .alreadyAdded:
				return "Already added"
			}
		}
	}

	// MARK: - Closures

	public var changeViewStatusClosure: ((ContractValidationStatus) -> Void)!

	// MARK: - Public Properties

	public var customAssetVM: CustomAssetViewModel?

	public let addCustomAssetButtonTitle = "Add"
    public let addCustomAssetLoadingButtonTitle = "Please wait"
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

	// MARK: - Private Properties

	private var getCustomAssetInfoRequestWork: DispatchWorkItem!
	private var readNodeContractKey = "0"
	private var userAddressStaticCode = "0x"

	private let coredataManager = CoreDataManager()

	// MARK: - Initializers

	init(useraddress: String) {
		self.userAddress = useraddress
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

	public func validateContractAddressBeforeRequest(textFieldText: String) {
		if textFieldText.isEmpty {
			changeViewStatusClosure(.clear)
			return
		}

		if textFieldText.validateETHContractAddress() {
			let lowercasedTextFieldText = textFieldText.lowercased()
			let foundToken = GlobalVariables.shared.manageAssetsList!
				.first(where: { $0.id.lowercased() == lowercasedTextFieldText })
			if foundToken != nil {
				changeViewStatusClosure(.error(.alreadyAdded))
				return
			} else {
				changeViewStatusClosure(.pending)
				Web3Core.shared.getCustomAssetInfo(contractAddress: textFieldText)
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
					}.catch { error in
						self.changeViewStatusClosure(.error(.networkError))
					}
			}
		} else {
			changeViewStatusClosure(.error(.notValid))
		}
	}

	public func saveCustomTokenToCoredata() -> CustomAsset? {
		guard let customAssetVM else { return nil }
		if coredataManager.getAllCustomAssets()
			.contains(where: { $0.id == customAssetVM.contractAddress.lowercased() }) {
			Toast.default(title: "Asset Exists", subtitle: nil, style: .error, direction: .bottom).show()
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
