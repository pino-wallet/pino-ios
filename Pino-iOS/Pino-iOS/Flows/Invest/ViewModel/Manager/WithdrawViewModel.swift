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
		if BigNumber(numberWithDecimal: tokenAmount) < maxAvailableAmount {
			return .decrease
		} else {
			return .withdrawMax
		}
	}

	// MARK: - Public Properties

	public var maxAvailableAmount: BigNumber!
	public var selectedToken: AssetViewModel!
	public var selectedProtocol: InvestProtocolViewModel
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var continueButtonTitle = "Withdraw"
	public var transactionType: SendTransactionType = .withdraw
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

	init(selectedAsset: AssetsBoardProtocol, selectedProtocol: InvestProtocolViewModel) {
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

	private func getToken(investableAsset: AssetsBoardProtocol) {
		let tokensList = GlobalVariables.shared.manageAssetsList!
		selectedToken = tokensList.first(where: { $0.symbol == investableAsset.assetName })!
		maxAvailableAmount = selectedToken.holdAmount
	}
}
