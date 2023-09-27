//
//  CollateralConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation

#warning("this values are static and should be changed")

struct CollateralConfirmViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Confirm collateral"
	public let protocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let confirmButtonTitle = "Confirm"
	#warning("this actionsheet texts are for test")
	public let feeActionSheetText = "this is fee"
	public let protocolActionsheetText = "this is protocol"
	#warning("this fee is mock and it should be removed")
	public let fee = "$10"
    
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
}
