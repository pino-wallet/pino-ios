//
//  EnterSendAmountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import Foundation
import BigInt

class EnterSendAmountViewModel {
    // MARK: - Public Properties
    
    public var isDollarEnabled: Bool
    public let maxTitle = "Max: "
    public let dollarIcon = "dollar_icon"
    public let continueButtonTitle = "Next"
    public let dollarSign = "$"
    public let avgSign = "≈"
    public let insufficientAmountButtonTitle = "Insufficient amount"
    public var selectedTokenChanged: (() -> Void)?
    public var textFieldPlaceHolder = "0"
    
    public var selectedToken: AssetViewModel {
        didSet {
            updateTokenMaxAmount()
            if let selectedTokenChanged {
                selectedTokenChanged()
            }
        }
    }
    
    public var maxHoldAmount: (number: BigNumber, formattedAmount: String) {
        set(newVal) {
            _number = newVal.number
            _formattedAmount = newVal.number.formattedAmountOf(type: .sevenDigitsRule)
        }
        get {
            
        }
    }
    public var maxAmountInDollar: (number: BigNumber, formattedAmount: String) {
        
    }
    public var tokenAmount = "0"
    public var dollarAmount = "0"
    
    public var formattedMaxHoldAmount: String {
        "\(maxHoldAmount.formattedAmount) \(selectedToken.symbol)"
    }
    
    public var formattedMaxAmountInDollar: String {
        "$ \(maxAmountInDollar.formattedAmount)"
    }
    
    public var formattedAmount: String {
        if isDollarEnabled {
            return "\(avgSign) \(tokenAmount) \(selectedToken.symbol)"
        } else {
            return "\(avgSign) $\(dollarAmount)"
        }
    }
    
    // MARK: - Initializers
    
    init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false) {
        self.selectedToken = selectedToken
        self.isDollarEnabled = isDollarEnabled
        updateTokenMaxAmount()
    }
    
    // MARK: - Public Methods
    
    public func calculateAmount(_ amount: String) {
        if isDollarEnabled {
            convertDollarAmountToTokenValue(amount: amount)
        } else {
            convertEnteredAmountToDollar(amount: amount)
        }
    }
    
    public func checkIfBalanceIsEnough(amount: String, amountStatus: (AmountStatus) -> Void) {
        if amount == .emptyString {
            amountStatus(.isZero)
        } else if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
            amountStatus(.isZero)
        } else {
            var decimalMaxAmount: BigNumber
            var enteredAmmount: BigNumber
            if isDollarEnabled {
                decimalMaxAmount = maxAmountInDollar.number
                enteredAmmount = BigNumber(numberWithDecimal: dollarAmount)
            } else {
                decimalMaxAmount = maxHoldAmount.number
                enteredAmmount = BigNumber(numberWithDecimal: tokenAmount)
            }
            if enteredAmmount > decimalMaxAmount {
                amountStatus(.isNotEnough)
            } else {
                amountStatus(.isEnough)
            }
        }
    }
    
    public func updateEthMaxAmount(
        gasFee: BigNumber = GlobalVariables.shared.ethGasFee.fee,
        gasFeeInDollar: BigNumber = GlobalVariables.shared.ethGasFee.feeInDollar
    ) {
        let estimatedAmount = selectedToken.holdAmount - gasFee
        maxHoldAmount = (estimatedAmount, estimatedAmount.formattedAmountOf(type: .sevenDigitsRule))
        
        let estimatedAmountInDollar = selectedToken.holdAmountInDollor - gasFeeInDollar
        maxAmountInDollar = (estimatedAmountInDollar, estimatedAmountInDollar.formattedAmountOf(type: .priceRule))
    }
    
    // MARK: - Private Methods
    
    private func updateTokenMaxAmount() {
        if selectedToken.isEth {
            updateEthMaxAmount()
        } else {
            maxHoldAmount = (selectedToken.holdAmount, selectedToken.holdAmount.formattedAmountOf(type: .sevenDigitsRule))
            maxAmountInDollar = (selectedToken.holdAmountInDollor, selectedToken.holdAmountInDollor.formattedAmountOf(type: .priceRule))
        }
    }
    
    private func convertEnteredAmountToDollar(amount: String) {
        
        let decimalBigNum = BigNumber(numberWithDecimal: amount)
        let price = selectedToken.price

        let amountInDollarDecimalValue = BigNumber(number: decimalBigNum.number * price.number, decimal: decimalBigNum.decimal + 6)
        dollarAmount = amountInDollarDecimalValue.formattedAmountOf(type: .priceRule)
        tokenAmount = amount
    }
    
    private func convertDollarAmountToTokenValue(amount: String) {
        let decimalBigNum = BigNumber(numberWithDecimal: amount).number * BigInt(10).power(6 + selectedToken.decimal)
        let price = selectedToken.price
       
        let tokenAmountDecimalValue = decimalBigNum.quotientAndRemainder(dividingBy: price.number)
        tokenAmount = BigNumber(number: tokenAmountDecimalValue.quotient, decimal: selectedToken.decimal).formattedAmountOf(type: .sevenDigitsRule)
        dollarAmount = amount
    }
}
