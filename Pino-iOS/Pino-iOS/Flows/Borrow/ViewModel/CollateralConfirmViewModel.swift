//
//  CollateralConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation
import Combine

#warning("this values are static and should be changed")

class CollateralConfirmViewModel {
    // MARK: - TypeAliases
    typealias FeeInfoType = (feeInDollars: String, feeInETH: String)
	// MARK: - Public Properties

	public let pageTitle = "Confirm collateral"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
    
    @Published public var feeInfo: FeeInfoType? = nil

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
		return collateralIncreaseAmountInDollars.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties
    private let sendTxErrorText = "Failed to send collateral transaction"
    private let feeTxErrorText = "Failed to estimate fee of transaction"
    
    private let web3 = Web3Core.shared
    private let ethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
    
    private lazy var aaveCollateralManager: AaveCollateralManager = {
        let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
        return AaveCollateralManager(contract: pinoAaveProxyContract, asset: selectedToken, assetAmount: collaterallIncreaseAmountVM.tokenAmount)
    }()
    #warning("i should add compound collateral manager here")

	private var collateralIncreaseAmountBigNumber: BigNumber {
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
    
    // MARK: - Public Methods
    public func getCollateralGasInfo() {
        switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
        case .aave:
            if selectedToken.isEth {
                aaveCollateralManager.getETHCollateralData().done { _, depositGasInfo in
                        self.aaveCollateralManager.getUserUseReserveAsCollateralData().done { userReserveGasInfo in
                            let totalFeeInDollars = depositGasInfo.feeInDollar + userReserveGasInfo.feeInDollar
                            let totalFeeInETH = depositGasInfo.fee + userReserveGasInfo.fee
                            self.feeInfo = (feeInDollars: totalFeeInDollars.priceFormat, feeInETH: totalFeeInETH.sevenDigitFormat.tokenFormatting(token: self.ethToken?.symbol ?? "ETH"))
                        }.catch { _ in
                            Toast.default(
                                title: self.feeTxErrorText,
                                subtitle: GlobalToastTitles.tryAgainToastTitle.message,
                                style: .error
                            )
                            .show(haptic: .warning)
                    }
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
                    self.aaveCollateralManager.getUserUseReserveAsCollateralData().done { userReserveGasInfo in
                        let totalFeeInDollars = depositGasInfo.feeInDollar + userReserveGasInfo.feeInDollar
                        let totalFeeInETH = depositGasInfo.fee + userReserveGasInfo.fee
                        self.feeInfo = (feeInDollars: totalFeeInDollars.priceFormat, feeInETH: totalFeeInETH.sevenDigitFormat.tokenFormatting(token: self.ethToken?.symbol ?? "ETH"))
                    }.catch { _ in
                        Toast.default(
                            title: self.feeTxErrorText,
                            subtitle: GlobalToastTitles.tryAgainToastTitle.message,
                            style: .error
                        )
                        .show(haptic: .warning)
                    }
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
            #warning("i should add compound collateral manager first to complete this section")
        default:
            print("Unknown selected dex system !")

        }
    }
    
    public func confirmCollateral(completion: @escaping () -> Void) {
        switch collaterallIncreaseAmountVM.borrowVM.selectedDexSystem {
        case .aave:
            aaveCollateralManager.confirmDeposit { result in
                switch result {
                case .fulfilled(_):
                    completion()
                case .rejected(_):
                    Toast.default(
                        title: self.sendTxErrorText,
                        subtitle: GlobalToastTitles.tryAgainToastTitle.message,
                        style: .error
                    )
                    .show(haptic: .warning)
                }
            }
        case .compound:
            #warning("i should add compound collateral manager first to complete this section")
            return
        default:
            print("Unknown selected dex system !")
        }
    }
}
