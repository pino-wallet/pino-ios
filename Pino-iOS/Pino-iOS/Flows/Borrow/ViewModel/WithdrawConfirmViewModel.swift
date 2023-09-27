//
//  WithdrawConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation

#warning("this values are static and should be changed")

struct WithdrawConfirmViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Confirm collateral withdrawal"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
	#warning("this fee is mock and it should be removed")
	public let fee = "$10"
    
    public let withdrawAmountVM: WithdrawAmountViewModel

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
    private var withdrawAmountBigNumber: BigNumber {
        BigNumber(numberWithDecimal: withdrawAmountVM.tokenAmount)
    }
    
    private var selectedToken: AssetViewModel {
        withdrawAmountVM.selectedToken
    }
    
    private var selectedDexSystem: DexSystemModel {
        withdrawAmountVM.borrowVM.selectedDexSystem
    }
    
    // MARK: - Initializers
    init(withdrawAmountVM: WithdrawAmountViewModel) {
        self.withdrawAmountVM = withdrawAmountVM
    }
}
