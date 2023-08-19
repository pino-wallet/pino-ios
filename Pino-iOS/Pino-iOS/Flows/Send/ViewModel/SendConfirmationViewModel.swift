//
//  SendConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3_Utility

class SendConfirmationViewModel {
	// MARK: - Private Properties

	private let coreDataManager = CoreDataManager()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()
	private let selectedWallet: AccountInfoViewModel
	private var cancellables = Set<AnyCancellable>()
	private var gasPrice = "0"
	private var gasLimit = "0"
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	// MARK: - Public Properties

	public let selectedToken: AssetViewModel
	public var gasFee: BigNumber!
	public var isAddressScam = false
	public let recipientAddress: String
	public let sendAmount: String
	public let confirmBtnText = "Confirm"
	public let insuffientText = "Insufficient ETH Amount"
	public let sendAmountInDollar: String

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
		sendAmount.tokenFormatting(token: selectedToken.symbol)
	}

	public var selectedWalletImage: String {
		selectedWallet.profileImage
	}

	public var selectedWalletName: String {
		selectedWallet.name
	}

	@Published
	public var formattedFeeInETH: String?

	@Published
	public var formattedFeeInDollar: String?

	public let selectedWalletTitle = "From"
	public let recipientAddressTitle = "To"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	public let scamConfirmButtonTitle = "Confirm Anyway"
	public let scamErrorTitle =
		"This address maybe be a scam! This address maybe be a scam! This address maybe be a scam!"
	public let feeInfoActionSheetTitle = "Fee"
	public let feeInfoActionSheetDescription = "Sample Text"
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"

	// MARK: - Initializer

	init(
		selectedToken: AssetViewModel,
		selectedWallet: AccountInfoViewModel,
		recipientAddress: String,
		sendAmount: String,
		sendAmountInDollar: String
	) {
		self.selectedToken = selectedToken
		self.selectedWallet = selectedWallet
		self.sendAmount = sendAmount
		self.sendAmountInDollar = sendAmountInDollar
		self.recipientAddress = recipientAddress
		setupBindings()
	}

	// MARK: - Public Methods

	public func checkEnoughBalance() -> Bool {
		if gasFee > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	public func getFee() -> Promise<String> {
		if selectedToken.isEth {
			return calculateEthGasFee()
		} else {
			return calculateTokenGasFee(ethPrice: ethToken.price)
		}
	}

	public func sendToken() -> Promise<String> {
		if selectedToken.isEth {
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .ether)
			return Web3Core.shared.sendEtherTo(address: recipientAddress, amount: sendAmount!)
		} else {
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .custom(selectedToken.decimal))
			return Web3Core.shared.sendERC20TokenTo(
                recipient: recipientAddress,
				amount: sendAmount!,
				tokenContractAddress: selectedToken.id
			)
		}
	}

	public func addPendingTransferActivity(trxHash: String) {
		let userAddress = walletManager.currentAccount.eip55Address
		coreDataManager.addNewTransferActivity(
			activityModel: ActivityTransferModel(
				txHash: trxHash,
				type: "transfer",
				detail: TransferActivityDetail(
					amount: Utilities
						.parseToBigUInt(sendAmount, units: .custom(selectedToken.decimal))!
						.description,
					tokenID: selectedToken.id,
					from: userAddress,
					to: recipientAddress
				),
				fromAddress: userAddress,
				toAddress: recipientAddress,
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: gasLimit,
				gasPrice: gasPrice
			),
			accountAddress: userAddress
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	// MARK: - Private Methods

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee.sink { fee, feeInDollar in
			self.gasFee = fee
			self.formattedFeeInETH = fee.sevenDigitFormat
			self.formattedFeeInDollar = feeInDollar.priceFormat
		}.store(in: &cancellables)
	}

	private func calculateEthGasFee() -> Promise<String> {
		Promise<String> { seal in
			_ = Web3Core.shared.calculateEthGasFee().done { gasInfo in
                let fee = BigNumber(unSignedNumber: gasInfo.fee, decimal: 18)
				self.gasFee = fee
                self.formattedFeeInDollar = gasInfo.feeInDollar.priceFormat
				self.formattedFeeInETH = fee.sevenDigitFormat.ethFormatting
                self.gasPrice = gasInfo.gasPrice.description
                self.gasLimit = gasInfo.gasLimit.description
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func calculateTokenGasFee(ethPrice: BigNumber) -> Promise<String> {
		Promise<String> { seal in
			let sendAmount = Utilities.parseToBigUInt(sendAmount, units: .custom(selectedToken.decimal))
			Web3Core.shared.calculateSendERCGasFee(
				address: recipientAddress,
				amount: sendAmount!,
				tokenContractAddress: selectedToken.id
			).done { [self] gasInfo in
                let fee = BigNumber(unSignedNumber: gasInfo.fee, decimal: 18)
                self.gasFee = fee
                self.formattedFeeInDollar = gasInfo.feeInDollar.priceFormat
                self.formattedFeeInETH = fee.sevenDigitFormat.ethFormatting
                self.gasPrice = gasInfo.gasPrice.description
                self.gasLimit = gasInfo.gasLimit.description
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
