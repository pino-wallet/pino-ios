//
//  BorrowConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import Foundation
import Web3
import Web3_Utility

#warning("this values are static and should be changed")

class BorrowConfirmViewModel {
	// MARK: - TypeAliases

	typealias FeeInfoType = (feeInDollars: String, feeInETH: String, bigNumberFee: BigNumber)
	typealias ConfirmBorrowClosureType = (EthereumSignedTransaction) -> Void

	// MARK: - Closures

	public var confirmBorrowClosure: ConfirmBorrowClosureType = { _ in }

	// MARK: - Public Properties

	public let pageTitle = "Confirm loan"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	public let loadingButtonTitle = "Please wait"
	public let insufficientAmountButtonTitle = "Insufficient ETH amount"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"

	@Published
	public var feeInfo: FeeInfoType? = nil

	public let borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel

	public var protocolImageName: String {
		selectedDexSystem.image
	}

	public var protocolName: String {
		selectedDexSystem.name
	}

	public var tokenAmountAndSymbol: String {
		tokenAmountBigNumber.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenAmountInDollars: String {
		let userTokenAmountInDollars = tokenAmountBigNumber * selectedToken.price
		return userTokenAmountInDollars.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties

	private let sendTxErrorText = "Failed to send borrow transaction"
	private let feeTxErrorText = "Failed to estimate fee of transaction"
	private let coredataManager = CoreDataManager()
	private let coreDataManager = CoreDataManager()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()

	private let web3 = Web3Core.shared

	private var tokenAmountBigNumber: BigNumber {
		BigNumber(numberWithDecimal: borrowIncreaseAmountVM.tokenAmount)
	}

	private var selectedToken: AssetViewModel {
		borrowIncreaseAmountVM.selectedToken
	}

	private var selectedDexSystem: DexSystemModel {
		borrowIncreaseAmountVM.borrowVM.selectedDexSystem
	}

	private lazy var aaveBorrowManager: AaveBorrowManager = {
		let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
		return AaveBorrowManager(
			contract: pinoAaveProxyContract,
			asset: selectedToken,
			assetAmount: borrowIncreaseAmountVM.tokenAmount
		)
	}()

	// MARK: - Initializers

	init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel) {
		self.borrowIncreaseAmountVM = borrowIncreaseAmountVM
	}

	// MARK: - Private Methods

	private func setFeeInfoByDepositGasInfo(depositGasInfo: GasInfo) {
		feeInfo = (
			feeInDollars: depositGasInfo.feeInDollar!.priceFormat,
			feeInETH: depositGasInfo.fee!.sevenDigitFormat.ethFormatting,
			bigNumberFee: depositGasInfo.fee!
		)
	}

	// MARK: - Public Methods

	public func createBorrowPendingActivity(txHash: String) {
		coreDataManager.addNewBorrowActivity(
			activityModel: ActivityBorrowModel(
				txHash: txHash,
				type: "borrow",
				detail: BorrowActivityDetails(
					activityProtocol: borrowIncreaseAmountVM.borrowVM.selectedDexSystem.type,
					token: ActivityTokenModel(
						amount: Utilities
							.parseToBigUInt(borrowIncreaseAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
							.description,
						tokenID: selectedToken.id
					)
				),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: aaveBorrowManager.borrowGasInfo!.increasedGasLimit!.description,
				gasPrice: aaveBorrowManager.borrowGasInfo!.maxFeePerGas.description
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	public func getBorrowGasInfo() {
		switch borrowIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			aaveBorrowManager.getERC20BorrowData().done { _, depositGasInfo in
				self.setFeeInfoByDepositGasInfo(depositGasInfo: depositGasInfo)
			}.catch { _ in
				Toast.default(
					title: self.feeTxErrorText,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		case .compound:
			#warning("i should add compound collateral manager first to complete this section")
		default:
			print("Unknown selected dex system !")
		}
	}

	public func confirmBorrow() {
		switch borrowIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			guard let borrowTRX = aaveBorrowManager.borrowTRX else {
				return
			}
			confirmBorrowClosure(borrowTRX)
		case .compound:
			#warning("i should add compound collateral manager first to complete this section")
			return
		default:
			print("Unknown selected dex system !")
		}
	}
}
