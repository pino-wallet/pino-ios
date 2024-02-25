//
//  EnterSendAddressViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//
import Combine
import Foundation

class EnterSendAddressViewModel {
	// MARK: - Closures

	public var ensAddressFound: ((_ name: String, _ address: String) -> Void)!

	// MARK: - Public Properties

	public let enterAddressPlaceholder = "Enter address"
	public let pageTitlePreFix = "Send"
	public let nextButtonTitle = "Next"
	public let qrCodeIconName = "qr_code_scanner"
	public var sendAmountVM: EnterSendAmountViewModel
	public var selectedWallet: AccountInfoViewModel!
	public var recipientAddress: SendRecipientAddress?

	public var sendAddressQrCodeScannerTitle: String {
		"Scan address to send \(sendAmountVM.selectedToken.symbol)"
	}

	@Published
	public var validationStatus: ValidationStatus

	public enum ValidationStatus: Equatable {
		case error(ValidationError)
		case success
		case normal
		case loading
	}

	public enum ValidationError: Error {
		case addressNotValid
		case sameAddress

		public var description: String {
			switch self {
			case .addressNotValid:
				return "Invalid address"
			case .sameAddress:
				return "It's your account!"
			}
		}
	}

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private let web3APIClient = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(sendAmountVM: EnterSendAmountViewModel) {
		self.sendAmountVM = sendAmountVM
		self.validationStatus = .normal
		getSelectedWallet()
	}

	// MARK: - Private Methods

	private func getSelectedWallet() {
		let currentWallet = CoreDataManager().getAllWalletAccounts().first(where: { $0.isSelected })
		selectedWallet = AccountInfoViewModel(walletAccountInfoModel: currentWallet)
	}

	private func validateRegularAddress(_ address: String) {
		if address.isEmpty {
			recipientAddress = nil
			validationStatus = .normal
			return
		}
		if address == pinoWalletManager.currentAccount.eip55Address {
			recipientAddress = nil
			validationStatus = .error(.sameAddress)
			return
		}
		if address.validateETHContractAddress() {
			validationStatus = .success
		} else {
			recipientAddress = nil
			validationStatus = .error(.addressNotValid)
		}
	}

	private func getENSAddress(_ ensName: String) {
		recipientAddress = .regularAddress(.emptyString)
		validationStatus = .loading
		web3APIClient.getEnsAddress(ensName: ensName)
			.sink { completed in
				switch completed {
				case .finished:
					print("ENS address received successfully")
				case let .failure(error):
					print("Error getting ENS address:\(error)")
					self.validationStatus = .error(.addressNotValid)
				}
			} receiveValue: { ensAddress in
				self.recipientAddress = .ensAddress(RecipientENSInfo(name: ensName, address: ensAddress.address))
				self.ensAddressFound(ensName, ensAddress.address)
				self.validateRegularAddress(ensAddress.address)
			}.store(in: &cancellables)
	}

	// MARK: - Public Methods

	public func validateSendAddress(address: String) {
		if address.isENSAddress() {
			getENSAddress(address)
		} else {
			recipientAddress = .regularAddress(address)
			validateRegularAddress(address)
		}
	}

	public func selectUserWallet(_ account: AccountInfoViewModel) {
		recipientAddress = .userWalletAddress(account)
		validateRegularAddress(account.address)
	}

	public func selectRecentAddress(name: String?, address: String) {
		guard let name else {
			recipientAddress = .regularAddress(address)
			validateRegularAddress(address)
			return
		}
		recipientAddress = .ensAddress(RecipientENSInfo(name: name, address: address))
		validateRegularAddress(address)
	}
}
