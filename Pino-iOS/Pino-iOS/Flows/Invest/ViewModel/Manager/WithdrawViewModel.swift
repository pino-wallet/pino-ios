//
//  WithdrawViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import BigInt
import Foundation

class WithdrawViewModel: InvestViewModelProtocol {
	// MARK: - Public Properties

	public var maxAvailableAmount: BigNumber!
	public var selectedInvestableAsset: InvestableAssetViewModel?
	public var selectedToken: AssetViewModel!
	public var selectedProtocol: InvestProtocolViewModel
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var continueButtonTitle = "Withdraw"
	public var pageTitle: String {
		"Withdraw \(selectedToken.symbol)"
	}

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
		} else {
			dollarAmount = .emptyString
		}
		tokenAmount = amount
	}

	public func calculateDollarAmount(_ amount: BigNumber) {
		let amountInDollarDecimalValue = amount * selectedToken.price
		dollarAmount = amountInDollarDecimalValue.priceFormat
		tokenAmount = amount.sevenDigitFormat
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
}
