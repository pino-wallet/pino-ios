//
//  CollateralConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Combine
import Foundation
import Web3
import Web3_Utility

class CollateralConfirmViewModel {
	// MARK: - TypeAliases

	typealias FeeInfoType = (feeInDollars: String, feeInETH: String, bigNumberFee: BigNumber)
	typealias ConfirmCollateralClosureType = ([SendTransactionViewModel]) -> Void

	// MARK: - Closures

	public var confirmCollateralClosure: ConfirmCollateralClosureType = { _ in }

	// MARK: - Public Properties

	public let pageTitle = "Confirm collateral"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Network Fee"
	public let confirmButtonTitle = "Confirm"
	public let loadingButtonTitle = "Please wait"
	public let insufficientAmountButtonTitle = "Insufficient ETH amount"
	public let feeActionSheetText = GlobalActionSheetTexts.networkFee.description
	#warning("this actionsheet texts are for test")
	public let protocolActionsheetText = "this is protocol"

	@Published
	public var feeInfo: FeeInfoType? = nil

	public let collaterallIncreaseAmountVM: CollateralIncreaseAmountViewModel

	public var protocolImageName: String {
		selectedDexSystem.image
	}

	public var protocolName: String {
		selectedDexSystem.name
	}

	public var tokenAmountAndSymbol: String {
		collateralIncreaseAmountBigNumber.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenAmountInDollars: String {
		let collateralIncreaseAmountInDollars = collateralIncreaseAmountBigNumber * selectedToken.price
		return collateralIncreaseAmountInDollars.priceFormat(of: selectedToken.assetType, withRule: .standard)
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties

	private let sendTxErrorText = "Failed to send collateral transaction"
	private let feeTxErrorText = "Failed to estimate fee of transaction"
	private let coredataManager = CoreDataManager()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()

	private let web3 = Web3Core.shared

	private lazy var aaveCollateralManager: AaveCollateralManager = {
		let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
		return AaveCollateralManager(
			contract: pinoAaveProxyContract,
			asset: selectedToken,
			assetAmount: collaterallIncreaseAmountVM.tokenAmount
		)
	}()

	private lazy var compoundDepositManager: CompoundDepositManager = {
		let pinoCompoundProxyContract = try! web3.getCompoundProxyContract()
		return CompoundDepositManager(
			contract: pinoCompoundProxyContract,
			selectedToken: selectedToken,
			investAmount: collaterallIncreaseAmountVM.tokenAmount,
			type: .collateral
		)
	}()

	private var collateralIncreaseAmountBigNumber: BigNumber! {
		BigNumber(numberWithDecimal: collaterallIncreaseAmountVM.tokenAmount)
	}

	private var selectedToken: AssetViewModel {
		collaterallIncreaseAmountVM.selectedToken
	}

	private var selectedDexSystem: DexSystemModel {
		collaterallIncreaseAmountVM.borrowVM.selectedDexSystem
	}

	// MARK: - Initializers

	init(collaterallIncreaseAmountVM: CollateralIncreaseAmountViewModel) {
		self.collaterallIncreaseAmountVM = collaterallIncreaseAmountVM
	}

	// MARK: - Private Methods

	private func setFeeInfoByDepositGasInfo(depositGasInfo: GasInfo) {
		feeInfo = (
			feeInDollars: depositGasInfo.feeInDollar!.priceFormat(of: selectedToken.assetType, withRule: .standard),
			feeInETH: depositGasInfo.fee!.sevenDigitFormat.ethFormatting,
			bigNumberFee: depositGasInfo.fee!
		)
	}

	private func setFeeInfosByDepositGasInfo(depositGasInfos: [GasInfo]) {
		feeInfo = (
			feeInDollars: depositGasInfos.map { $0.feeInDollar! }.reduce(0.bigNumber, +)
				.priceFormat(of: selectedToken.assetType, withRule: .standard),
			feeInETH: depositGasInfos.map { $0.fee! }.reduce(0.bigNumber, +).sevenDigitFormat.ethFormatting,
			bigNumberFee: depositGasInfos.map { $0.fee! }.reduce(0.bigNumber, +)
		)
	}

	private func createCollateralPendingActivity(txHash: String, isEnabledCollateral: Bool) {
		var activityType: String!
		switch collaterallIncreaseAmountVM.collateralMode {
		case .increase:
			activityType = "increase_collateral"
		case .create:
			activityType = "create_collateral"
		}
		let zeroAmountBigNumber = 0.bigNumber
		var gasUsed: String
		var gasPrice: String
		switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			gasUsed = aaveCollateralManager.depositGasInfo!.increasedGasLimit!.bigIntFormat
			gasPrice = aaveCollateralManager.depositGasInfo!.maxFeePerGas.bigIntFormat
		case .compound:
			if isEnabledCollateral {
				gasUsed = (
					compoundDepositManager.collateralCheckGasInfo!.increasedGasLimit
				)!.bigIntFormat
				gasPrice = (
					compoundDepositManager.collateralCheckGasInfo!.baseFeeWithPriorityFee
				)
				.bigIntFormat
			} else {
				gasUsed = (
					compoundDepositManager.depositGasInfo!
						.increasedGasLimit!
				).bigIntFormat
				gasPrice = (
					compoundDepositManager.depositGasInfo!
						.baseFeeWithPriorityFee
				)
				.bigIntFormat
			}
		default:
			fatalError("Unknown dex type")
		}
		var activityDate: Date {
			if isEnabledCollateral {
				Date() + 1
			} else {
				Date()
			}
		}

		coredataManager.addNewCollateralActivity(
			activityModel: ActivityCollateralModel(
				txHash: txHash,
				type: activityType,
				detail: CollateralActivityDetails(
					activityProtocol: selectedDexSystem.type,
					tokens: [ActivityTokenModel(
						amount: Utilities
							.parseToBigUInt(collaterallIncreaseAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
							.description,
						tokenID: selectedToken.id
					)]
				),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: activityDate),
				gasUsed: gasUsed,
				gasPrice: gasPrice
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	private func createInvestPendingActivity(txHash: String) {
		let zeroAmountBigNumber = 0.bigNumber
		var gasUsed: String
		var gasPrice: String
		switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			gasUsed = aaveCollateralManager.depositGasInfo!.increasedGasLimit!.bigIntFormat
			gasPrice = aaveCollateralManager.depositGasInfo!.baseFeeWithPriorityFee.bigIntFormat
		case .compound:
			gasUsed = (
				compoundDepositManager.depositGasInfo!
					.increasedGasLimit! +
					(compoundDepositManager.collateralCheckGasInfo?.increasedGasLimit ?? zeroAmountBigNumber)
			).bigIntFormat
			gasPrice = (
				compoundDepositManager.depositGasInfo!
					.baseFeeWithPriorityFee +
					(compoundDepositManager.collateralCheckGasInfo?.baseFeeWithPriorityFee ?? zeroAmountBigNumber)
			)
			.bigIntFormat
		default:
			fatalError("Unknown dex type")
		}
		coredataManager.addNewInvestActivity(
			activityModel: ActivityInvestModel(
				txHash: txHash,
				type: "create_investment",
				detail: InvestmentActivityDetails(tokens: [ActivityTokenModel(
					amount: Utilities
						.parseToBigUInt(collaterallIncreaseAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
						.description,
					tokenID: selectedToken.id
				)], positionId: "", activityProtocol: selectedDexSystem.type, nftId: nil),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: gasUsed,
				gasPrice: gasPrice
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	// MARK: - Public Methods

	public func getCollateralGasInfo() {
		switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			if selectedToken.isEth {
				aaveCollateralManager.getETHCollateralData().done { _, depositGasInfo in
					self.setFeeInfoByDepositGasInfo(depositGasInfo: depositGasInfo)
				}.catch { _ in
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			} else {
				aaveCollateralManager.getERC20CollateralData().done { _, depositGasInfo in
					self.setFeeInfoByDepositGasInfo(depositGasInfo: depositGasInfo)
				}.catch { _ in
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			}
		case .compound:
			switch collaterallIncreaseAmountVM.collateralMode {
			case .increase:
				compoundDepositManager.getIncreaseDepositInfo().done { depositGasInfos in
					self.setFeeInfosByDepositGasInfo(depositGasInfos: depositGasInfos)
				}.catch { _ in
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}

			case .create:
				compoundDepositManager.getDepositInfo().done { depositGasInfos in
					self.setFeeInfosByDepositGasInfo(depositGasInfos: depositGasInfos)
				}.catch { _ in
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			}
		default:
			print("Unknown selected dex system !")
		}
	}

	public func confirmCollateral() {
		switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			guard let depositTRX = aaveCollateralManager.depositTRX else {
				return
			}
			let depositTransaction = SendTransactionViewModel(transaction: depositTRX) { pendingActivityTXHash in
				self.createCollateralPendingActivity(txHash: pendingActivityTXHash, isEnabledCollateral: false)
			}
			confirmCollateralClosure([depositTransaction])
		case .compound:
			guard let depositTrx = compoundDepositManager.depositTrx else { return }
			var depositTransaction: SendTransactionViewModel!
			if let collateralCheckTrx = compoundDepositManager.collateralCheckTrx {
				depositTransaction = SendTransactionViewModel(transaction: depositTrx) { [self] pendingActivityTXHash in
					createInvestPendingActivity(txHash: pendingActivityTXHash)
				}
				let collateralCheckTransaction =
					SendTransactionViewModel(transaction: collateralCheckTrx) { pendingActivityTXHash in
						self.createCollateralPendingActivity(txHash: pendingActivityTXHash, isEnabledCollateral: true)
					}
				confirmCollateralClosure([depositTransaction, collateralCheckTransaction])
			} else {
				depositTransaction = SendTransactionViewModel(transaction: depositTrx) { [self] pendingActivityTXHash in
					createCollateralPendingActivity(txHash: pendingActivityTXHash, isEnabledCollateral: false)
				}
				confirmCollateralClosure([depositTransaction])
			}
		default:
			print("Unknown selected dex system !")
		}
	}
}
