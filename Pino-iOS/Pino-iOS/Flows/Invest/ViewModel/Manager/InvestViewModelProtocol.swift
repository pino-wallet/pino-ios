//
//  InvestViewModelProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import Foundation
import PromiseKit
import Web3_Utility

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
	func checkAllowance(of tokenAddress: String) -> Promise<Bool>
	func getTokenAddress() -> Promise<String>
}

extension InvestViewModelProtocol {
	var maxTitle: String { "Available: " }
	var insufficientAmountButtonTitle: String { "Insufficient amount" }
	var textFieldPlaceHolder: String { "0" }
	var estimatedReturnTitle: String { "Yearly estimated return" }
	var formattedMaxHoldAmount: String {
		maxAvailableAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	func checkAllowance(of tokenAddress: String) -> Promise<Bool> {
		if tokenAddress == GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })?.id {
			return Promise.value(true)
		}
		return Promise { seal in
			let web3 = Web3Core.shared
			let walletManager = PinoWalletManager()
			firstly {
				try web3.getAllowanceOf(
					contractAddress: tokenAddress,
					spenderAddress: Web3Core.Constants.permitAddress,
					ownerAddress: walletManager.currentAccount.eip55Address
				)
			}.done { [self] allowanceAmount in
				let destTokenDecimal = selectedToken.decimal
				let destTokenAmount = Utilities.parseToBigUInt(tokenAmount, decimals: destTokenDecimal)
				if allowanceAmount == 0 || allowanceAmount < destTokenAmount! {
					// NOT ALLOWED
					seal.fulfill(false)
				} else {
					// ALLOWED
					seal.fulfill(true)
				}
			}.catch { error in
				print("Error: getting token allowance: \(error)")
				seal.reject(error)
			}
		}
	}
}

enum InvestmentType {
	case create
	case increase
}
