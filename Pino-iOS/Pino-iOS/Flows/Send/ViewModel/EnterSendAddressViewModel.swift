//
//  EnterSendAddressViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//
import Foundation

class EnterSendAddressViewModel {
	// MARK: - Closures

	public var didValidateSendAddress: (ValidationStatus) -> Void = { _ in }

	// MARK: - Public Properties

	public let enterAddressPlaceholder = "Enter address"
	public let pageTitlePreFix = "Send"
	public let nextButtonTitle = "Next"
	public let qrCodeIconName = "qr_code_scanner"
	public var sendAmountVM: EnterSendAmountViewModel
	public var selectedWallet: AccountInfoViewModel!

	public enum ValidationStatus: Equatable {
		case error(ValidationError)
		case success
		case normal
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

	// MARK: - Initializers

	init(sendAmountVM: EnterSendAmountViewModel) {
		self.sendAmountVM = sendAmountVM
		getSelectedWallet()
	}

	// MARK: - Private Methods

	private func getSelectedWallet() {
		let currentWallet = CoreDataManager().getAllWalletAccounts().first(where: { $0.isSelected })
		selectedWallet = AccountInfoViewModel(walletAccountInfoModel: currentWallet)
	}

	// MARK: - Public Methods

	public func validateSendAddress(address: String) {
		if address.isEmpty {
			didValidateSendAddress(.normal)
			return
		}
		if address == pinoWalletManager.currentAccount.eip55Address {
			didValidateSendAddress(.error(.sameAddress))
			return
		}
		if address.validateETHContractAddress() {
			didValidateSendAddress(.success)
		} else {
			didValidateSendAddress(.error(.addressNotValid))
		}
	}
}
