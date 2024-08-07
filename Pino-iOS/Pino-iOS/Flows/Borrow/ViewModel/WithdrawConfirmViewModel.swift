//
//  WithdrawConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Combine
import Foundation
import Web3
import Web3_Utility
import Web3ContractABI

class WithdrawConfirmViewModel {
	// MARK: - TypeAliases

	typealias FeeInfoType = (feeInDollars: String, feeInETH: String, bigNumberFee: BigNumber)
	typealias ConfirmWithdrawClosureType = ([SendTransactionViewModel]) -> Void

	// MARK: - Closures

	public var confirmWithdrawClosure: ConfirmWithdrawClosureType = { _ in }

	// MARK: - Public Properties

	public let pageTitle = "Confirm withdraw withdrawal"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Network fee"
	public let confirmButtonTitle = "Confirm"
	public let loadingButtonTitle = "Please wait"
	public let insufficientAmountButtonTitle = "Insufficient ETH amount"
	public let feeActionSheetText = GlobalActionSheetTexts.networkFee.description
	#warning("this actionsheet texts are for test")
	public let protocolActionsheetText = "this is protocol"

	@Published
	public var feeInfo: FeeInfoType? = nil

	public let withdrawAmountVM: WithdrawAmountViewModel
	public var withdrawMode: WithdrawMode

	public var protocolImageName: String {
		selectedDexSystem.image
	}

	public var protocolName: String {
		selectedDexSystem.name
	}

	public var tokenAmountAndSymbol: String {
		withdrawAmountBigNumber.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenAmountInDollars: String {
		let withdrawAmountInDollars = withdrawAmountBigNumber * selectedToken.price
		return withdrawAmountInDollars.priceFormat(of: selectedToken.assetType, withRule: .standard)
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private let coreDataManager = CoreDataManager()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()

	private var withdrawAmountBigNumber: BigNumber! {
		BigNumber(numberWithDecimal: withdrawAmountVM.tokenAmount)
	}

	private var selectedToken: AssetViewModel {
		withdrawAmountVM.selectedToken
	}

	private var selectedDexSystem: DexSystemModel {
		withdrawAmountVM.borrowVM.selectedDexSystem
	}

	private let feeTxErrorText = "Failed to estimate fee of transaction"

	private lazy var aaveWithdrawManager: AaveWithdrawManager = {
		let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
		return AaveWithdrawManager(
			contract: pinoAaveProxyContract,
			asset: selectedToken,
			assetAmount: withdrawAmountVM.tokenAmount,
			positionAsset: withdrawAmountVM.aavePositionToken!
		)
	}()

	private lazy var compoundWithdrawManager: CompoundWithdrawManager = {
		let pinoCompoundProxyContract = try! web3.getCompoundProxyContract()
		return CompoundWithdrawManager(
			contract: pinoCompoundProxyContract,
			selectedToken: selectedToken,
			withdrawAmount: withdrawAmountVM.tokenAmount
		)
	}()

	// MARK: - Initializers

	init(withdrawAmountVM: WithdrawAmountViewModel) {
		self.withdrawAmountVM = withdrawAmountVM
		let assetAmountBigNumber = BigNumber(numberWithDecimal: withdrawAmountVM.tokenAmount)!
		if assetAmountBigNumber.sevenDigitFormat == withdrawAmountVM.maxWithdrawAmount.sevenDigitFormat {
			self.withdrawMode = .withdrawMax
		} else {
			self.withdrawMode = .decrease
		}
	}

	// MARK: - Private Methods

	private func setFeeInfoByDepositGasInfo(withdrawGasinfo: GasInfo) {
		feeInfo = (
			feeInDollars: withdrawGasinfo.feeInDollar!.priceFormat(of: selectedToken.assetType, withRule: .standard),
			feeInETH: withdrawGasinfo.fee!.sevenDigitFormat.ethFormatting,
			bigNumberFee: withdrawGasinfo.fee!
		)
	}

	// MARK: - Public Methods

	public func createWithdrawPendingActivity(txHash: String, gasInfo: GasInfo) {
		var activityType: String {
			switch withdrawMode {
			case .decrease:
				return "decrease_collateral"
			case .withdrawMax:
				return "remove_collateral"
			}
		}

		coreDataManager.addNewCollateralActivity(
			activityModel: ActivityCollateralModel(
				txHash: txHash,
				type: activityType,
				detail: CollateralActivityDetails(
					activityProtocol: withdrawAmountVM.borrowVM.selectedDexSystem.type,
					tokens: [ActivityTokenModel(
						amount: Utilities.parseToBigUInt(withdrawAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!
							.description,
						tokenID: selectedToken.id
					)]
				),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: gasInfo.increasedGasLimit!.bigIntFormat,
				gasPrice: gasInfo.baseFeeWithPriorityFee.bigIntFormat
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	public func getWithdrawGasInfo() {
		switch withdrawAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			if withdrawMode == .withdrawMax {
				aaveWithdrawManager.getERC20WithdrawMaxData().done { _, withdrawGasInfo in
					self.setFeeInfoByDepositGasInfo(withdrawGasinfo: withdrawGasInfo)
				}.catch { _ in
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			} else {
				aaveWithdrawManager.getERC20WithdrawData().done { _, withdrawGasInfo in
					self.setFeeInfoByDepositGasInfo(withdrawGasinfo: withdrawGasInfo)
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
			compoundWithdrawManager.getWithdrawInfo(withdrawType: withdrawMode).done { _, withdrawGasInfo in
				self.setFeeInfoByDepositGasInfo(withdrawGasinfo: withdrawGasInfo)
			}.catch { _ in
				Toast.default(
					title: self.feeTxErrorText,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		default:
			print("Unknown selected dex system !")
		}
	}

	public func confirmWithdraw() {
		switch withdrawAmountVM.borrowVM.selectedDexSystem {
		case .aave:
			guard let withdrawTRX = aaveWithdrawManager.withdrawTRX else {
				return
			}
			let withdrawTransaction = SendTransactionViewModel(
				transaction: withdrawTRX,
				addPendingActivityClosure: { txHash in
					self.createWithdrawPendingActivity(txHash: txHash, gasInfo: self.aaveWithdrawManager.withdrawGasInfo!)
				}
			)
			confirmWithdrawClosure([withdrawTransaction])
		case .compound:
			guard let withdrawTRX = compoundWithdrawManager.withdrawTrx else {
				return
			}
			let withdrawTransaction = SendTransactionViewModel(
				transaction: withdrawTRX,
				addPendingActivityClosure: { txHash in
					self.createWithdrawPendingActivity(
						txHash: txHash,
						gasInfo: self.compoundWithdrawManager.withdrawGasInfo!
					)
				}
			)
			confirmWithdrawClosure([withdrawTransaction])
		default:
			print("Unknown selected dex system !")
		}
	}
}
