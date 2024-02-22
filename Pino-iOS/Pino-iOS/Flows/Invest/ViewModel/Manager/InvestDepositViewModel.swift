//
//  InvestDepositViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import BigInt
import Combine
import Foundation

class InvestDepositViewModel: InvestViewModelProtocol {
	// MARK: - Private Properties

	private var investmentType: InvestmentType
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var tokenAmount = "0"
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

	@Published
	public var hasOpenPosition: Bool?

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
		if let amountBigNumber = BigNumber(numberWithDecimal: amount) {
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
		tokenAmount = amount.decimalString
		getYearlyEstimatedReturn(amountInDollar: amountInDollarDecimalValue)
	}

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if hasOpenPosition == nil {
			return .isZero
		} else if let hasOpenPosition, hasOpenPosition {
			return .isZero
		}
		guard let amountBigNumber = BigNumber(numberWithDecimal: amount) else {
			return .isZero
		}
		if amountBigNumber.isZero ||
			amountBigNumber.decimal > selectedToken.decimal {
			return .isZero
		}
		if amountBigNumber <= maxAvailableAmount {
			return .isEnough
		} else {
			return .isNotEnough
		}
	}

	// MARK: - Private Methods

	private func getToken(investableAsset: AssetsBoardProtocol) {
		let tokensList = GlobalVariables.shared.manageAssetsList!
		selectedToken = tokensList.first(where: { $0.id.lowercased() == investableAsset.assetId.lowercased() })!
		maxAvailableAmount = selectedToken.holdAmount
		getTokenPositionID { [self] positionId in
			let tokenPosition = tokensList.first(where: { $0.id == positionId })!
			if investmentType == .create, tokenPosition.holdAmount > 0.bigNumber {
				hasOpenPosition = true
			} else {
				hasOpenPosition = false
			}
		}
	}

	private func getYearlyEstimatedReturn(amountInDollar: BigNumber?) {
		if let selectedInvestableAsset, let amountInDollar, let hasOpenPosition, !hasOpenPosition {
			let yearlyReturnBigNumber = amountInDollar * selectedInvestableAsset.APYAmount / 100.bigNumber
			yearlyEstimatedReturn = yearlyReturnBigNumber?.priceFormat
		} else {
			yearlyEstimatedReturn = nil
		}
	}

	private func getTokenPositionID(completion: @escaping (String) -> Void) {
		let w3APIClient = Web3APIClient()
		w3APIClient.getTokenPositionID(
			tokenAdd: selectedToken.id.lowercased(),
			positionType: .investment,
			protocolName: selectedProtocol.rawValue
		).sink { completed in
			switch completed {
			case .finished:
				print("Position id received successfully")
			case let .failure(error):
				print("Error getting position id:\(error)")
			}
		} receiveValue: { tokenPositionModel in
			completion(tokenPositionModel.positionID.lowercased())
		}.store(in: &cancellables)
	}
}
