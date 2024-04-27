//
//  InvestConfirmationProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import Foundation
import PromiseKit
import Web3ContractABI

protocol InvestConfirmationProtocol: InvestConfirmationViewProtocol {
	var selectedToken: AssetViewModel { get }
	var selectedProtocol: InvestProtocolViewModel { get }
	var transactionAmount: String { get }
	var transactionAmountInDollar: String { get }
	var formattedTransactionAmount: String { get }
	var formattedTransactionAmountInDollar: String { get }
	var formattedFeeInETH: String? { get }
	var formattedFeeInDollar: String? { get }
	var formattedFeeInETHPublisher: Published<String?>.Publisher { get }
	var formattedFeeInDollarPublisher: Published<String?>.Publisher { get }
	var userBalanceIsEnough: Bool { get }
	var investProxyContract: DynamicContract { get }
	var gasFee: BigNumber! { get }
	var ethToken: AssetViewModel { get }
	var isTokenVerified: Bool { get }
	var tokenImage: URL { get }
	var customAssetImage: String { get }
	var selectedProtocolImage: String { get }
	var selectedProtocolName: String { get }
	var pageTitle: String { get }
	var sendTransactions: [SendTransactionViewModel]? { get }
	var transactionsDescription: String { get }
	func getTransactionInfo() -> Promise<Void>
}

protocol InvestConfirmationViewProtocol {
	var selectedProtocolTitle: String { get }
	var feeTitle: String { get }
	var feeInfoActionSheetTitle: String { get }
	var feeInfoActionSheetDescription: String { get }
	var protocolInfoActionSheetTitle: String { get }
	var protocolInfoActionSheetDescription: String { get }
	var feeErrorText: String { get }
	var feeErrorIcon: String { get }
	var confirmButtonTitle: String { get }
	var insuffientButtonTitle: String { get }
	var failedToAuthTitle: String { get }
}

extension InvestConfirmationViewProtocol {
	var selectedProtocolTitle: String { "Protocol" }
	var feeTitle: String { "Network Fee" }
	var feeInfoActionSheetTitle: String { GlobalActionSheetTexts.networkFee.title }
	var feeInfoActionSheetDescription: String { GlobalActionSheetTexts.networkFee.description }
	var protocolInfoActionSheetTitle: String { "Protocol" }
	var protocolInfoActionSheetDescription: String { "Sample Text" }
	var feeErrorText: String { "Error in calculation!" }
	var feeErrorIcon: String { "refresh" }
	var confirmButtonTitle: String { "Confirm" }
	var insuffientButtonTitle: String { "Insufficient amount" }
	var failedToAuthTitle: String { "Failed to Authenticate" }
}

extension InvestConfirmationProtocol {
	var isTokenVerified: Bool {
		selectedToken.isVerified
	}

	var tokenImage: URL {
		selectedToken.image
	}

	var customAssetImage: String {
		selectedToken.customAssetImage
	}

	var selectedProtocolImage: String {
		selectedProtocol.image
	}

	var selectedProtocolName: String {
		selectedProtocol.name
	}

	var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	var formattedTransactionAmount: String {
		let transactionBigNumber = BigNumber(numberWithDecimal: transactionAmount)
		return transactionBigNumber!.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	var formattedTransactionAmountInDollar: String {
		transactionAmountInDollar
	}
}
