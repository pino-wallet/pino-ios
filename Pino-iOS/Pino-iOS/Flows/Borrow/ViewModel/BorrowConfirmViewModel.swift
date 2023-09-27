//
//  BorrowConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import Foundation

#warning("this values are static and should be changed")

struct BorrowConfirmViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Confirm loan"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
	#warning("this fee is mock and it should be removed")
	public let fee = "$10"
    
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
    
    // MARK: - Initializers
    init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel) {
        self.borrowIncreaseAmountVM = borrowIncreaseAmountVM
    }
}
