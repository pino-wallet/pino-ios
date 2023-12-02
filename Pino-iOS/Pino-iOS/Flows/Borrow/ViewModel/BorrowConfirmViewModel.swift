//
//  BorrowConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import Foundation
import Web3

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

	private var tokenAmountBigNumber: BigNumber {
		BigNumber(numberWithDecimal: borrowIncreaseAmountVM.tokenAmount)
	}

	private var selectedToken: AssetViewModel {
		borrowIncreaseAmountVM.selectedToken
	}

	private var selectedDexSystem: DexSystemModel {
		borrowIncreaseAmountVM.borrowVM.selectedDexSystem
	}
    
    
    private lazy var aaveCollateralManager: AaveCollateralManager = {
        let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
        return AaveCollateralManager(
            contract: pinoAaveProxyContract,
            asset: selectedToken,
            assetAmount: collaterallIncreaseAmountVM.tokenAmount
        )
    }()

	// MARK: - Initializers

	init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel) {
		self.borrowIncreaseAmountVM = borrowIncreaseAmountVM
	}
    
    
    // MARK: - Public Methods
    
    public func getBorrowGasInfo() {
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
            #warning("i should add compound collateral manager first to complete this section")
        default:
            print("Unknown selected dex system !")
        }
    }
}
