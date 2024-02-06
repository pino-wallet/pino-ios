//
//  WithdrawViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import BigInt
import Combine
import Foundation

class WithdrawViewModel: InvestViewModelProtocol {
	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private var withdrawType: WithdrawMode {
		let tokenAmoutBigNumber = BigNumber(numberWithDecimal: tokenAmount) ?? 0.bigNumber
		if tokenAmoutBigNumber < maxAvailableAmount {
			return .decrease
		} else {
			return .withdrawMax
		}
	}

	// MARK: - Public Properties

	public var maxAvailableAmount: BigNumber!
	public var selectedToken: AssetViewModel!
	public var selectedProtocol: InvestProtocolViewModel
	public var tokenAmount = "0"
	public var dollarAmount: String = .emptyString
	public var continueButtonTitle = "Withdraw"
	public var pageTitle: String {
		"Withdraw \(selectedToken.symbol)"
	}

	public var approveType: ApproveContractViewController.ApproveType = .withdraw
	public var investConfirmationVM: InvestConfirmationProtocol {
		WithdrawConfirmationViewModel(
			selectedToken: selectedToken,
			selectedProtocol: selectedProtocol,
			withdrawAmount: tokenAmount,
			withdrawAmountInDollar: dollarAmount,
			withdrawType: withdrawType
		)
	}

	// MARK: - Initializers

	init(selectedAsset: InvestAssetViewModel, selectedProtocol: InvestProtocolViewModel) {
		self.selectedProtocol = selectedProtocol
		getToken(investmentAsset: selectedAsset)
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if let amountBigNumber = BigNumber(numberWithDecimal: amount) {
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
		} else if let amountBigNum = BigNumber(numberWithDecimal: amount), amountBigNum.isZero {
			return .isZero
		} else if let amountBigNum = BigNumber(numberWithDecimal: tokenAmount), amountBigNum <= maxAvailableAmount {
			return .isEnough
		} else {
			return .isNotEnough
		}
	}

	public func getTokenPositionID(completion: @escaping (String) -> Void) {
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

	// MARK: - Private Methods

	private func getToken(investmentAsset: InvestAssetViewModel) {
		let tokensList = GlobalVariables.shared.manageAssetsList!
		selectedToken = tokensList.first(where: { $0.id.lowercased() == investmentAsset.assetId.lowercased() })!
		maxAvailableAmount = investmentAsset.tokenAmount
	}
}
