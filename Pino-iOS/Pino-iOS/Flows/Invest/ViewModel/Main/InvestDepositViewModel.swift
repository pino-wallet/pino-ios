//
//  InvestDepositViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import BigInt
import Foundation

class InvestDepositViewModel {
    // MARK: - Public Properties

    public let maxTitle = "Available: "
    public let continueButtonTitle = "Deposit"
    public let insufficientAmountButtonTitle = "Insufficient amount"
    public var textFieldPlaceHolder = "0"
    public var tokenAmount: String = .emptyString
    public var dollarAmount: String = .emptyString
    public var maxHoldAmount: BigNumber!

    public var formattedMaxHoldAmount: String {
        maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
    }
    
    public var pageTitle: String {
        "Invest in \(selectedToken.symbol)"
    }
    
    public var selectedToken: AssetViewModel! {
        didSet {
            updateTokenMaxAmount()
        }
    }

    // MARK: - Initializers

    init(selectedAsset: InvestableAssetViewModel) {
        getToken(investableAsset: selectedAsset)
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
    
    public func checkBalanceStatus(amount: String) -> AmountStatus {
        if amount == .emptyString {
            return .isZero
        } else if BigNumber(numberWithDecimal: amount).isZero {
            return .isZero
        } else {
            if BigNumber(numberWithDecimal: tokenAmount) > maxHoldAmount {
                return .isNotEnough
            } else {
                return .isEnough
            }
        }
    }

    public func updateEthMaxAmount(
        gasFee: BigNumber = GlobalVariables.shared.ethGasFee.fee,
        gasFeeInDollar: BigNumber = GlobalVariables.shared.ethGasFee.feeInDollar
    ) {
        let estimatedAmount = selectedToken.holdAmount - gasFee
        if estimatedAmount.number.sign == .minus {
            maxHoldAmount = 0.bigNumber
        } else {
            maxHoldAmount = estimatedAmount
        }
    }

    // MARK: - Private Methods

    private func updateTokenMaxAmount() {
        if selectedToken.isEth {
            updateEthMaxAmount()
        } else {
            maxHoldAmount = selectedToken.holdAmount
        }
    }
    
    private func getToken(investableAsset: InvestableAssetViewModel) {
        let tokensList = GlobalVariables.shared.manageAssetsList!
        self.selectedToken = tokensList.first(where: {$0.symbol == investableAsset.assetName})!
        updateTokenMaxAmount()
    }
}
