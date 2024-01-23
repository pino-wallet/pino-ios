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
import Web3
import Web3_Utility

class SendConfirmationViewModel {
	// MARK: - TypeAliases

	typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

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

	private var pendingSwapTrx: EthereumSignedTransaction?

	// MARK: - Public Properties

	public let selectedToken: AssetViewModel
	public var gasFee: BigNumber!
	public var isAddressScam = false
	public let recipientAddress: String
	public var userRecipientAccountInfoVM: UserAccountInfoViewModel?
	public let sendAmount: String
	public let confirmBtnText = "Confirm"
	public let insuffientText = "Insufficient ETH Amount"
	public let sendAmountInDollar: String
	public var sendStatusText: String {
		"You sent \(sendAmount.formattedNumberWithCamma) \(selectedToken.symbol) to \(recipientAddress)"
	}

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

	public var sendTransactions: [SendTransactionViewModel]? {
		guard let swapTrx = pendingSwapTrx else { return nil }
		let swapTrxStatus = SendTransactionViewModel(transaction: swapTrx) { pendingActivityTXHash in
			self.addPendingTransferActivity(trxHash: pendingActivityTXHash)
		}
		return [swapTrxStatus]
	}

	@Published
	public var formattedFeeInETH: String?

	@Published
	public var formattedFeeInDollar: String?

	public let selectedWalletTitle = "From"
	public let recipientAddressTitle = "To"
	public let feeTitle = "Network Fee"
	public let confirmButtonTitle = "Confirm"
	public let scamConfirmButtonTitle = "Confirm Anyway"
	public let scamErrorTitle =
		"This address maybe be a scam! This address maybe be a scam! This address maybe be a scam!"
	public let feeInfoActionSheetTitle = "Network Fee"
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
		setUserRecipientAccountInfo()
	}

	// MARK: - Public Methods

	public func checkEnoughBalance() -> Bool {
		if gasFee > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	public func getFee(completion: ((Error) -> Void)? = nil) {
		getSendTrxInfo().done { [self] trxWithGas in
			pendingSwapTrx = trxWithGas.0
			let gasInfo = trxWithGas.1
			gasFee = gasInfo.fee
			formattedFeeInDollar = gasInfo.feeInDollar!.priceFormat
			formattedFeeInETH = gasInfo.fee!.sevenDigitFormat.ethFormatting
			gasPrice = gasInfo.baseFeeWithPriorityFee.bigIntFormat
			gasLimit = gasInfo.gasLimit!.bigIntFormat
		}.catch { error in
			completion?(error)
		}
	}

	public func getSendTrxInfo() -> TrxWithGasInfo {
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
				blockTime: activityHelper.getServerFormattedStringDate(date: .now),
				gasUsed: gasLimit,
				gasPrice: gasPrice
			),
			accountAddress: userAddress
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	public func setRecentAddress() {
		var recentAdds = UserDefaults.standard.value(forKey: "recentSentAddresses") as! [String]
		recentAdds.insert(recipientAddress, at: 0)
		UserDefaults.standard.set(recentAdds, forKey: "recentSentAddresses")
	}

	// MARK: - Private Methods

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee
			.compactMap { $0 }
			.sink { gasInfo in
				self.getFee()
			}.store(in: &cancellables)
	}

	private func setUserRecipientAccountInfo() {
		let accountsList = walletManager.accounts
		let foundAccount = accountsList.first(where: { $0.eip55Address == recipientAddress })
		if let foundAccount {
            userRecipientAccountInfoVM = UserAccountInfoViewModel(accountIconName: foundAccount.avatarIcon, accountIconColorName: foundAccount.avatarColor, accountName: foundAccount.name, accountAddress: foundAccount.eip55Address)
		} else {
			userRecipientAccountInfoVM = nil
		}
	}
}
