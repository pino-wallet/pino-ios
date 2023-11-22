//
//  InvestDepositViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import BigInt
import Foundation

class InvestDepositViewModel: InvestViewModelProtocol {
	// MARK: - Public Properties

	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var maxAvailableAmount: BigNumber!
	public var selectedInvestableAsset: InvestableAssetViewModel?
	public var selectedToken: AssetViewModel!
	public var selectedProtocol: InvestProtocolViewModel
	public var continueButtonTitle = "Deposit"
	public var pageTitle: String {
		"Invest in \(selectedToken.symbol)"
	}

	@Published
	public var yearlyEstimatedReturn: String?

	// MARK: - Initializers

	init(selectedAsset: AssetsBoardProtocol, selectedProtocol: InvestProtocolViewModel) {
		self.selectedInvestableAsset = selectedAsset as? InvestableAssetViewModel
		self.selectedProtocol = selectedProtocol
		getToken(investableAsset: selectedAsset)
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if amount != .emptyString {
			let amountBigNumber = BigNumber(numberWithDecimal: amount)
			let amountInDollarDecimalValue = amountBigNumber * selectedToken.price
			dollarAmount = amountInDollarDecimalValue.priceFormat
			getYearlyEstimatedReturn(amountInDollar: amountInDollarDecimalValue)
		} else {
			dollarAmount = .emptyString
			getYearlyEstimatedReturn(amountInDollar: nil)
		}
		tokenAmount = amount
	}

	public func calculateDollarAmount(_ amount: BigNumber) {
		let amountInDollarDecimalValue = amount * selectedToken.price
		dollarAmount = amountInDollarDecimalValue.priceFormat
		tokenAmount = amount.sevenDigitFormat
		getYearlyEstimatedReturn(amountInDollar: amountInDollarDecimalValue)
	}

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if BigNumber(numberWithDecimal: amount).isZero {
			return .isZero
		} else {
			if BigNumber(numberWithDecimal: tokenAmount) > maxAvailableAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

	// MARK: - Private Methods

	private func getToken(investableAsset: AssetsBoardProtocol) {
		let tokensList = GlobalVariables.shared.manageAssetsList!
		selectedToken = tokensList.first(where: { $0.symbol == investableAsset.assetName })!
		maxAvailableAmount = selectedToken.holdAmount
	}

	private func getYearlyEstimatedReturn(amountInDollar: BigNumber?) {
		if let selectedInvestableAsset, let amountInDollar {
			let yearlyReturnBigNumber = amountInDollar * selectedInvestableAsset.APYAmount / 100.bigNumber
			yearlyEstimatedReturn = yearlyReturnBigNumber?.priceFormat
		} else {
			yearlyEstimatedReturn = nil
		}
	}
}