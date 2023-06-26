//
//  SendConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3_Utility

class SendConfirmationViewModel {
	// MARK: - Private Properties

	private let selectedToken: AssetViewModel
	private let selectedWallet: AccountInfoViewModel
	private let sendAmount: String
	private let sendAmountInDollar: String

	// MARK: - Public Properties

	public var gasFee: BigNumber?
	public var ethPrice: BigNumber!
	public var isAddressScam = false
	public let recipientAddress: String

	public var isTokenVerified: Bool {
		selectedToken.isVerified
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var customAssetImage: String {
		selectedToken.customAssetImage
	}

	public var formattedSendAmount: String {
		"\(sendAmount) \(selectedToken.symbol)"
	}

	public var formattedSendAmountInDollar: String? {
		"$\(sendAmountInDollar)"
	}

	public var selectedWalletImage: String {
		selectedWallet.profileImage
	}

	public var selectedWalletName: String {
		selectedWallet.name
	}

	@Published
	public var formattedFee: String?

	public let selectedWalletTitle = "From"
	public let recipientAddressTitle = "To"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	public let scamConfirmButtonTitle = "Confirm Anyway"
	public let scamErrorTitle =
		"This address maybe be a scam! This address maybe be a scam! This address maybe be a scam!"
	public let feeInfoActionSheetTitle = "Fee"
	public let feeInfoActionSheetDescription = "Sample Text"

	// MARK: - Initializer

	init(
		selectedToken: AssetViewModel,
		selectedWallet: AccountInfoViewModel,
		recipientAddress: String,
		sendAmount: String,
		sendAmountInDollar: String,
		ethPrice: BigNumber
	) {
		self.selectedToken = selectedToken
		self.selectedWallet = selectedWallet
		self.sendAmount = sendAmount
		self.sendAmountInDollar = sendAmountInDollar
		self.recipientAddress = recipientAddress
		self.ethPrice = ethPrice
	}

	// MARK: - Public Methods

	public func getFee() -> Promise<String> {
		if selectedToken.isEth {
			let calculatedGas = calculateEthGasFee()
			_ = calculatedGas.done { formattedFee in
				self.formattedFee = formattedFee
			}
			return calculatedGas
		} else {
			let calculatedGas = calculateTokenGasFee(ethPrice: ethPrice)
			_ = calculatedGas.done { formattedFee in
				self.formattedFee = formattedFee
			}
			return calculatedGas
		}
	}

	public func sendToken() -> Promise<String> {
		if selectedToken.isEth {
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .ether)
			return Web3Core.shared.sendEtherTo(address: recipientAddress, amount: sendAmount!)
		} else {
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .custom(selectedToken.decimal))
			return Web3Core.shared.sendERC20TokenTo(
				address: recipientAddress,
				amount: sendAmount!,
				tokenContractAddress: selectedToken.id
			)
		}
	}

	// MARK: - Private Methods

	private func calculateEthGasFee() -> Promise<String> {
		Promise<String> { seal in
			_ = Web3Core.shared.calculateEthGasFee(ethPrice: selectedToken.price).done { fee, feeInDollar in
				self.gasFee = fee
				seal
					.fulfill("$\(feeInDollar.formattedAmountOf(type: .price)) / \(fee.formattedAmountOf(type: .hold)) ETH")
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func calculateTokenGasFee(ethPrice: BigNumber) -> Promise<String> {
		Promise<String> { seal in
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .custom(selectedToken.decimal))
			Web3Core.shared.calculateERCGasFee(
				address: recipientAddress,
				amount: sendAmount!,
				tokenContractAddress: selectedToken.id,
				ethPrice: ethPrice
			).done { [self] fee, feeInDollar in
				gasFee = fee
				seal
					.fulfill(
						"$\(feeInDollar.formattedAmountOf(type: .price)) / \(fee.formattedAmountOf(type: .hold)) ETH"
					)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
