//
//  RepayConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation

#warning("this values are static and should be changed")

struct RepayConfirmViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Confirm repayment"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
	#warning("this fee is mock and it should be removed")
	public let fee = "$10"
    
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
    private var repayAmountBigNumber: BigNumber {
        BigNumber(numberWithDecimal: repayAmountVM.tokenAmount)
    }
    
    private var selectedToken: AssetViewModel {
        repayAmountVM.selectedToken
    }
    
    private var selectedDexSystem: DexSystemModel {
        repayAmountVM.borrowVM.selectedDexSystem
    }
    
    
    // MARK: - Initializers
    init(repayamountVM: RepayAmountViewModel) {
        self.repayAmountVM = repayamountVM
    }
}
