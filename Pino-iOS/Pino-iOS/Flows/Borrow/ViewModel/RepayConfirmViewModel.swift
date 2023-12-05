//
//  RepayConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Combine
import Foundation
import Web3
import Web3_Utility

class RepayConfirmViewModel {
	// MARK: - TypeAliases

	typealias FeeInfoType = (feeInDollars: String, feeInETH: String, bigNumberFee: BigNumber)
	typealias ConfirmRepayClosureType = (EthereumSignedTransaction) -> Void

	// MARK: - Closures

	public var confirmRepayClosure: ConfirmRepayClosureType = { _ in }

	// MARK: - Public Properties

	public let pageTitle = "Confirm repayment"
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

	public let repayAmountVM: RepayAmountViewModel

	public var protocolImageName: String {
		selectedDexSystem.image
	}

	public var protocolName: String {
		selectedDexSystem.name
	}

	public var tokenAmountAndSymbol: String {
		repayAmountBigNumber.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenAmountInDollars: String {
		let repayAmountInDollars = repayAmountBigNumber * selectedToken.price
		return repayAmountInDollars.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties

	private let feeTxErrorText = "Failed to estimate fee of transaction"
	private let web3 = Web3Core.shared
	private let coreDataManager = CoreDataManager()
	private let activityHelper = ActivityHelper()
	private let walletManager = PinoWalletManager()

	private var repayAmountBigNumber: BigNumber {
		BigNumber(numberWithDecimal: repayAmountVM.tokenAmount)
	}

	private var selectedToken: AssetViewModel {
		repayAmountVM.selectedToken
	}

	private var selectedDexSystem: DexSystemModel {
		repayAmountVM.borrowVM.selectedDexSystem
	}

	private lazy var aaveRepayManager: AaveRepayManager = {
		let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
		return AaveRepayManager(
			contract: pinoAaveProxyContract,
			asset: selectedToken,
			assetAmount: repayAmountVM.tokenAmount
		)
	}()

	// MARK: - Initializers

	init(repayamountVM: RepayAmountViewModel) {
		self.repayAmountVM = repayamountVM
	}

	// MARK: - Private Methods

	private func setFeeInfoByDepositGasInfo(repayGasinfo: GasInfo) {
		feeInfo = (
			feeInDollars: repayGasinfo.feeInDollar!.priceFormat,
			feeInETH: repayGasinfo.fee!.sevenDigitFormat.ethFormatting,
			bigNumberFee: repayGasinfo.fee!
		)
	}

	// MARK: - Public Methods

	public func createRepayPendingActivity(txHash: String) {
		coreDataManager.addNewRepayActivity(
			activityModel: ActivityRepayModel(
				txHash: txHash,
				type: "repay",
				detail: RepayActivityDetails(
					activityProtocol: repayAmountVM.borrowVM.selectedDexSystem.type,
					repaidToken: ActivityTokenModel(
						amount: Utilities
							.parseToBigUInt(repayAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
							.description,
						tokenID: selectedToken.id
					),
					repaidWithToken: ActivityTokenModel(
						amount: Utilities.parseToBigUInt(repayAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
							.description,
						tokenID: selectedToken.id
					)
				),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: aaveRepayManager.repayGasInfo!.increasedGasLimit!.description,
				gasPrice: aaveRepayManager.repayGasInfo!.maxFeePerGas.description
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	public func getRepayGasInfo() {
		switch repayAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			aaveRepayManager.getERC20RepayData().done { _, repayGasInfo in
				self.setFeeInfoByDepositGasInfo(repayGasinfo: repayGasInfo)
			}.catch { _ in
				Toast.default(
					title: self.feeTxErrorText,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		case .compound:
			#warning("i should add compound repay manager first to complete this section")
		default:
			print("Unknown selected dex system !")
		}
	}

	public func confirmRepay() {
		switch repayAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			guard let repayTRX = aaveRepayManager.repayTRX else {
				return
			}
			confirmRepayClosure(repayTRX)
		case .compound:
			#warning("i should add compound repay manager first to complete this section")
			return
		default:
			print("Unknown selected dex system !")
		}
	}
}
