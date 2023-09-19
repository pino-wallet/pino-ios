//
//  RepayAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

#warning("this values are static and mock")
class RepayAmountViewModel {
	// MARK: - Public Properties
    public enum RepayAmountStatus {
        case isNotEnough
        case isEnough
        case isZero
        case amountExceedsDebt
    }

	public let pageTitleRepayText = "Repay"
	public let insufficientAmountButtonTitle = "Insufficient amount"
    public let amountExceedsDebtButtonTitle = "Amount exceeds debt"
	public let continueButtonTitle = "Repay"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

    public var selectedUserBorrowingToken: UserBorrowingToken
    
	
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
    // check if user have more than his debt, use his debt for max amount to repay, otherwise use user amount in token to repay the debt
    public var maxHoldAmount: BigNumber {
        if selectedToken.holdAmount >= selectedTokenTotalDebt {
            return selectedTokenTotalDebt
        } else {
            return selectedToken.holdAmount
        }
    }
    public var tokenSymbol: String {
        selectedToken.symbol
    }
    public var selectedToken: AssetViewModel {
        (GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == selectedUserBorrowingToken.id }))!
    }

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}
    
    public var maxHoldAmountInDollars: String {
        maxHoldAmount.priceFormat
    }
    
    public var tokenImage: URL {
        selectedToken.image
    }
    
    public var sevenDigitMaxHoldAmount: String {
        maxHoldAmount.sevenDigitFormat
    }
    
    
    #warning("this is mock")
    public var prevHealthScore: Double = 0
    public var newHealthScore: Double = 24
    
    // MARK: - Private Properties
    private var selectedTokenTotalDebt: BigNumber {
        BigNumber(number: selectedUserBorrowingToken.totalDebt!, decimal: selectedToken.decimal)
    }
    // MARK: - Initializers
    init(selectedUserBorrowingToken: UserBorrowingToken) {
        self.selectedUserBorrowingToken = selectedUserBorrowingToken
    }

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if amount != .emptyString {
			let decimalBigNum = BigNumber(numberWithDecimal: amount)
			let price = selectedToken.price

			let amountInDollarDecimalValue = BigNumber(
				number: decimalBigNum.number * price.number,
				decimal: decimalBigNum.decimal + 6
			)
			dollarAmount = amountInDollarDecimalValue.priceFormat
		} else {
			dollarAmount = .emptyString
		}
		tokenAmount = amount
	}

	public func checkBalanceStatus(amount: String) -> RepayAmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if BigNumber(numberWithDecimal: amount).isZero {
			return .isZero
		} else {
            let bignumberTokenAmount = BigNumber(numberWithDecimal: tokenAmount)
            if bignumberTokenAmount > selectedToken.holdAmount {
                return .isNotEnough
            } else if bignumberTokenAmount > selectedTokenTotalDebt {
				return .amountExceedsDebt
			} else {
				return .isEnough
			}
		}
	}
}
