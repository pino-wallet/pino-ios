//
//  InvestDepositViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import BigInt
import Foundation

class InvestDepositViewModel: InvestViewModelProtocol {
	// MARK: - Private Properties

	private var investmentType: InvestmentType

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

	public var positionErrorText: String {
		"You have an open \(selectedToken.symbol) collateral position in \(selectedProtocol.name), which you need to close before depositing \(selectedToken.symbol) as investment."
	}

	public var hasOpenPosition: Bool!

	@Published
	public var yearlyEstimatedReturn: String?

	public var approveType: ApproveContractViewController.ApproveType = .invest
	public var investConfirmationVM: InvestConfirmationProtocol {
		InvestConfirmationViewModel(
			selectedToken: selectedToken,
			selectedProtocol: selectedProtocol,
			investAmount: tokenAmount,
			investAmountInDollar: dollarAmount,
			investmentType: investmentType
		)
	}

	// MARK: - Initializers

	init(
		selectedAsset: AssetsBoardProtocol,
		selectedProtocol: InvestProtocolViewModel,
		investmentType: InvestmentType
	) {
		self.selectedInvestableAsset = selectedAsset as? InvestableAssetViewModel
		self.selectedProtocol = selectedProtocol
		self.investmentType = investmentType
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
		if hasOpenPosition {
			return .isZero
		} else if amount == .emptyString {
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
		selectedProtocol = .aave
		#warning("it must be refactored later")
		if investmentType == .create, selectedToken.holdAmount > 0.bigNumber {
			hasOpenPosition = true
		} else {
			hasOpenPosition = false
		}
	}

	private func getYearlyEstimatedReturn(amountInDollar: BigNumber?) {
		if let selectedInvestableAsset, let amountInDollar, !hasOpenPosition {
			let yearlyReturnBigNumber = amountInDollar * selectedInvestableAsset.APYAmount / 100.bigNumber
			yearlyEstimatedReturn = yearlyReturnBigNumber?.priceFormat
		} else {
			yearlyEstimatedReturn = nil
		}
	}
}
