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
	private let ensName: String?
	private var cancellables = Set<AnyCancellable>()
	private var gasPrice = "0"
	private var gasLimit = "0"
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	private var pendingSwapTrx: EthereumSignedTransaction?
	private var sendAmount: BigNumber

	// MARK: - Public Properties

	public let selectedToken: AssetViewModel
	public var gasFee: BigNumber = 0.bigNumber
	public var isAddressScam = false
	public let recipientAddress: String
	public var userRecipientAccountInfoVM: UserAccountInfoViewModel?
	public let confirmBtnText = "Confirm"
	public let insuffientText = "Insufficient ETH Amount"
	public var sendStatusText: String {
		"You sent \(formattedSendAmount) to \(recipientAddress.addressFormating())"
	}

	public var sendAmountMinusFee: BigNumber {
		if selectedToken.isERC20 {
			return sendAmount - gasFee
		} else {
			if sendAmount == ethToken.holdAmount {
				return sendAmount - gasFee
			} else {
				return sendAmount - gasFee
			}
		}
	}

	public var sendAmountInDollar: BigNumber {
		sendAmountMinusFee * ethToken.price
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
		sendAmountMinusFee.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
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

	@Published
	public var feeCalculationState = FeeState.loading

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
		ensName: String?
	) {
		self.selectedToken = selectedToken
		self.selectedWallet = selectedWallet
		self.sendAmount = BigNumber(numberWithDecimal: sendAmount)!
		self.recipientAddress = recipientAddress
		self.ensName = ensName
		setupBindings()
		setUserRecipientAccountInfo()
	}

	// MARK: - Public Methods

	public func checkEnoughBalance() -> Bool {
		if selectedToken.isEth {
			if gasFee > ethToken.holdAmount - sendAmount {
				return false
			} else {
				return true
			}
		} else {
			if gasFee > ethToken.holdAmount {
				return false
			} else {
				return true
			}
		}
	}

	public func getFee() {
		feeCalculationState = .loading
		getSendTrxInfo().done { [self] trxWithGas in
			pendingSwapTrx = trxWithGas.0
			let gasInfo = trxWithGas.1
			gasFee = gasInfo.fee!
			formattedFeeInDollar = gasInfo.feeInDollar!.priceFormat
			formattedFeeInETH = gasInfo.fee!.sevenDigitFormat.ethFormatting
			gasPrice = gasInfo.baseFeeWithPriorityFee.bigIntFormat
			gasLimit = gasInfo.gasLimit!.bigIntFormat
			feeCalculationState = .hasValue
		}.catch { error in
			self.feeCalculationState = .error
		}
	}

	public func getSendTrxInfo() -> TrxWithGasInfo {
		if selectedToken.isEth {
			let sendAmount = Utilities.parseToBigUInt(sendAmountMinusFee.decimalString, units: .ether)
			return Web3Core.shared.sendEtherTo(address: recipientAddress, amount: sendAmount!)
		} else {
			let sendAmount = Utilities.parseToBigUInt(
				sendAmountMinusFee.decimalString,
				units: .custom(selectedToken.decimal)
			)
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
						.parseToBigUInt(sendAmountMinusFee.decimalString, units: .custom(selectedToken.decimal))!
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
		let recentAddressHelper = RecentAddressHelper()
		recentAddressHelper.addNewRecentAddress(newRecentAddress: RecentAddressModel(
			address: recipientAddress,
			userAddress: walletManager.currentAccount.eip55Address,
			date: Date(),
			ensName: ensName
		))
	}

	public func removeBindings() {
		cancellables.removeAll()
	}

	// MARK: - Private Methods

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee
			.compactMap { $0 }
			.sink { gasInfoDetils in
				if gasInfoDetils.isLoading {
					self.feeCalculationState = .loading
				} else {
					self.getFee()
				}
			}.store(in: &cancellables)
	}

	private func setUserRecipientAccountInfo() {
		let accountsList = walletManager.accounts
		let foundAccount = accountsList.first(where: { $0.eip55Address == recipientAddress })
		if let foundAccount {
			userRecipientAccountInfoVM = UserAccountInfoViewModel(
				accountIconName: foundAccount.avatarIcon,
				accountIconColorName: foundAccount.avatarColor,
				accountName: foundAccount.name,
				accountAddress: foundAccount.eip55Address
			)
		} else if let ensName {
			userRecipientAccountInfoVM = UserAccountInfoViewModel(
				accountIconName: nil,
				accountIconColorName: nil,
				accountName: ensName,
				accountAddress: recipientAddress
			)
		} else {
			userRecipientAccountInfoVM = nil
		}
	}
}

extension SendConfirmationViewModel {
	public enum FeeState {
		case hasValue
		case loading
		case error
	}
}
