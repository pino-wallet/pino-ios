//
//  InvestViewModelProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import Foundation

protocol InvestViewModelProtocol {
	var pageTitle: String { get }
	var continueButtonTitle: String { get }
	var maxTitle: String { get }
	var insufficientAmountButtonTitle: String { get }
	var textFieldPlaceHolder: String { get }
	var estimatedReturnTitle: String { get }
	var tokenAmount: String { get set }
	var dollarAmount: String { get set }
	var maxAvailableAmount: BigNumber! { get }
	var selectedToken: AssetViewModel! { get }
	var selectedProtocol: InvestProtocolViewModel { get }
	var formattedMaxHoldAmount: String { get }
	var approveType: ApproveContractViewController.ApproveType { get }
	var investConfirmationVM: InvestConfirmationProtocol { get }
	func calculateDollarAmount(_ amount: String)
	func calculateDollarAmount(_ amount: BigNumber)
	func checkBalanceStatus(amount: String) -> AmountStatus
}

extension InvestViewModelProtocol {
	var maxTitle: String { "Available: " }
	var insufficientAmountButtonTitle: String { "Insufficient amount" }
	var textFieldPlaceHolder: String { "0" }
	var estimatedReturnTitle: String { "Yearly estimated return" }
	var formattedMaxHoldAmount: String {
		maxAvailableAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}
}

enum InvestmentType {
	case create
	case increase
}
