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
	public var selectedAsset: AssetViewModel
	public var enteredAmount: String
	public enum ValidationStatus {
		case error(ValidationError)
		case success
		case pending
		case normal
	}

	public enum ValidationError: Error {
		case addressNotValid

		public var description: String {
			switch self {
			case .addressNotValid:
				return "Invalid address"
			}
		}
	}

	// MARK: - Initializers

	init(selectedAsset: AssetViewModel, enteredAmount: String) {
		self.selectedAsset = selectedAsset
		self.enteredAmount = enteredAmount
	}

	// MARK: - Public Methods

	public func validateSendAddress(address: String) {
		if address.isEmpty {
			didValidateSendAddress(.normal)
			return
		}
		if address.validateETHContractAddress() {
			#warning("add more validation here, this is just for test")
			didValidateSendAddress(.pending)
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.didValidateSendAddress(.success)
			}
		} else {
			didValidateSendAddress(.error(.addressNotValid))
		}
	}
}
