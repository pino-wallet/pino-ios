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

	// MARK: - Closures

	public var changeViewStatusClosure: ((ContractValidationStatus) -> Void)!

	// MARK: - Public Properties

	public var customAssetVM: CustomAssetViewModel?

	public let addCustomAssetButtonTitle = "Add"
	public let addCustomAssetLoadingButtonTitle = "Please wait"
	public let addcustomAssetPageTitle = "Add custom asset"
	public let addCustomAssetPageBackButtonIcon = "dismiss"
	public let addCustomAssetTextfieldPlaceholder = "Enter contract address"
	public let addCustomAssetTextfieldError = "This is an error!"
	public let addCustomAssetTextfieldIcon = "qr_code_scanner"
	public let customAssetQrCodeScannetTitle = "Scan contract address"

	public var customAssetNameInfo: CustomAssetInfoViewModel
	public var customAssetUserBalanceInfo: CustomAssetInfoViewModel
	public var customAssetSymbolInfo: CustomAssetInfoViewModel
	public var customAssetDecimalInfo: CustomAssetInfoViewModel
	public var userAddress: String

	// MARK: - Private Properties

	private var getCustomAssetInfoRequestWork: DispatchWorkItem!
	private var readNodeContractKey = "0"
	private var userAddressStaticCode = "0x"
	private var currentValidationStatus: ContractValidationStatus = .clear

	private let coredataManager = CoreDataManager()
	private let currentAccountAddress = PinoWalletManager().currentAccount.eip55Address

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
			if currentValidationStatus == .clear {
				changeViewStatusClosure(.pasteFromClipboard(clipboardText))
				currentValidationStatus = .pasteFromClipboard(clipboardText)
			}
		}
	}

	public func validateContractAddressBeforeRequest(textFieldText: String) {
		if textFieldText.isEmpty {
			changeViewStatusClosure(.clear)
			currentValidationStatus = .clear
			return
		}

		if textFieldText.validateETHContractAddress() {
			let lowercasedTextFieldText = textFieldText.lowercased()
			let foundToken = GlobalVariables.shared.manageAssetsList!
				.first(where: { $0.id.lowercased() == lowercasedTextFieldText })
			if foundToken != nil {
				changeViewStatusClosure(.error(.alreadyAdded))
				currentValidationStatus = .error(.alreadyAdded)
				return
			} else {
				changeViewStatusClosure(.pending)
				currentValidationStatus = .pending
				let contractChecksumAddress = Web3Core.shared.getChecksumOfEip55Address(eip55Address: textFieldText)
				Web3Core.shared.getCustomAssetInfo(contractAddress: contractChecksumAddress)
					.done { [weak self] assetInfo in
						if let name = assetInfo[.name]?.description,
						   let symbol = assetInfo[.symbol]?.description,
						   let balance = assetInfo[.balance]?.description,
						   let decimal = assetInfo[.decimal]?.description {
							self?.customAssetVM = CustomAssetViewModel(customAsset: CustomAssetModel(
								id: contractChecksumAddress.trimmingCharacters(in: .whitespaces),
								name: name,
								symbol: symbol,
								balance: balance,
								decimal: decimal
							))
							self?.changeViewStatusClosure(.success)
							self?.currentValidationStatus = .success
						}
					}.catch { error in
						self.changeViewStatusClosure(.error(.tryAgain))
						self.currentValidationStatus = .error(.tryAgain)
					}
			}
		} else {
			changeViewStatusClosure(.error(.notValid))
			currentValidationStatus = .error(.notValid)
		}
	}

	public func saveCustomTokenToCoredata() -> CustomAsset? {
		guard let customAssetVM else { return nil }
		let userAllCustomAssets = coredataManager.getAllCustomAssets()
			.filter { $0.accountAddress.lowercased() == currentAccountAddress.lowercased() }
		if userAllCustomAssets
			.contains(where: { $0.id.lowercased() == customAssetVM.contractAddress.lowercased() }) {
			Toast.default(title: "Asset Exists", subtitle: nil, style: .error, direction: .bottom).show()
			return nil
		} else {
			let customAssetModel = coredataManager.addNewCustomAsset(
				id: customAssetVM.contractAddress,
				symbol: customAssetVM.symbol,
				name: customAssetVM.name,
				decimal: customAssetVM.decimal,
				accountAddress: currentAccountAddress.lowercased()
			)
			return customAssetModel
		}
	}
}
