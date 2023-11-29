//
//  WithdrawConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation
import Combine
import Web3
import Web3_Utility

#warning("this values are static and should be changed")

class WithdrawConfirmViewModel {
    // MARK: - TypeAliases
    
    typealias FeeInfoType = (feeInDollars: String, feeInETH: String, bigNumberFee: BigNumber)
    typealias ConfirmWithdrawClosureType = (EthereumSignedTransaction) -> Void
    
    // MARK: - Closures
    public var confirmWithdrawClosure: ConfirmWithdrawClosureType = {_ in}
	// MARK: - Public Properties

	public let pageTitle = "Confirm withdraw withdrawal"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
    public let confirmButtonTitle = "Confirm"
    public let loadingButtonTitle = "Please wait"
    public let insufficientAmountButtonTitle = "Insufficient ETH amount"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
	#warning("this fee is mock and it should be removed")
	public let fee = "$10"
    
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
		return withdrawAmountInDollars.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}
    
    // MARK: - Private Properties
    private let web3 = Web3Core.shared
    private let coreDataManager = CoreDataManager()
    private let walletManager = PinoWalletManager()
    private let activityHelper = ActivityHelper()

    private var withdrawAmountBigNumber: BigNumber {
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

    // MARK: - Initializers

    init(withdrawAmountVM: WithdrawAmountViewModel) {
        self.withdrawAmountVM = withdrawAmountVM
        let assetAmountBigNumber = BigNumber(numberWithDecimal: withdrawAmountVM.tokenAmount)
        if assetAmountBigNumber.plainSevenDigitFormat == withdrawAmountVM.maxWithdrawAmount.plainSevenDigitFormat {
            self.withdrawMode = .withdraw
        } else {
            self.withdrawMode = .decrease
        }
    }
    
    // MARK: - Private Methods
    
    private func setFeeInfoByDepositGasInfo(depositGasInfo: GasInfo) {
        feeInfo = (
            feeInDollars: depositGasInfo.feeInDollar.priceFormat,
            feeInETH: depositGasInfo.fee.sevenDigitFormat.ethFormatting,
            bigNumberFee: depositGasInfo.fee
        )
    }

    // MARK: - Public Methods
    
    public func createWithdrawPendingActivity(txHash: String) {
        var activityType: String {
            switch withdrawMode {
            case .decrease:
                return "decrease_collateral"
            case .withdraw:
                return "remove_collateral"
            }
        }
        coreDataManager.addNewCollateralActivity(activityModel: ActivityCollateralModel(txHash: txHash, type: activityType, detail: CollateralActivityDetails(activityProtocol: withdrawAmountVM.borrowVM.selectedDexSystem.type, tokens: [ActivityTokenModel(amount: Utilities.parseToBigUInt(withdrawAmountVM.tokenAmount, units: .custom(selectedToken.decimal))!.description, tokenID: selectedToken.id)]), fromAddress: "", toAddress: "", blockTime: activityHelper.getServerFormattedStringDate(date: Date()), gasUsed: aaveWithdrawManager.withdrawGasInfo!.increasedGasLimit.description, gasPrice: aaveWithdrawManager.withdrawGasInfo!.gasPrice.description), accountAddress: walletManager.currentAccount.eip55Address)
            PendingActivitiesManager.shared.startActivityPendingRequests()
    }
    
    public func getWithdrawGasInfo() {
        switch withdrawAmountVM.borrowVM.selectedDexSystem {
        case .aave:
            if selectedToken.isEth {
                aaveWithdrawManager.getETHWithdrawData().done { _, depositGasInfo in
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
                aaveWithdrawManager.getERC20WithdrawData().done { _, depositGasInfo in
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
            #warning("i should add compound withdraw manager first to complete this section")
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
            confirmWithdrawClosure(withdrawTRX)
        case .compound:
            #warning("i should add compound collateral manager first to complete this section")
            return
        default:
            print("Unknown selected dex system !")
        }
    }
}
