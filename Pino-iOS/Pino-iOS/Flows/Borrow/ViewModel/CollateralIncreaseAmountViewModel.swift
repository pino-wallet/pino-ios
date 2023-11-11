//
//  CollateralIncreaseAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation
import PromiseKit
import Web3_Utility

class CollateralIncreaseAmountViewModel {
	// MARK: - TypeAliases

	typealias AllowanceDataType = (hasAllowance: Bool, selectedTokenId: String)

	// MARK: - Public Properties

	public let pageTitleCollateralText = "Collateral"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Deposit"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

	public let selectedToken: AssetViewModel
	public let borrowVM: BorrowViewModel

	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var maxHoldAmount: BigNumber {
		selectedToken.holdAmount
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.plainSevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var maxAmountInDollars: String {
		selectedToken.holdAmountInDollor.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private let walletManager = PinoWalletManager()

	#warning("this is mock")
	public var prevHealthScore: Double = 0
	public var newHealthScore: Double = 24

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, borrowVM: BorrowViewModel) {
		self.selectedToken = selectedToken
		self.borrowVM = borrowVM
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

	public func didUserHasAllowanceForToken() -> Promise<AllowanceDataType> {
		Promise<AllowanceDataType> { seal in
			if selectedToken.isEth && borrowVM
				.selectedDexSystem == .compound {
				seal.fulfill((hasAllowance: true, selectedTokenId: selectedToken.id))
			}

			var selectedAllowenceToken: AssetViewModel {
				if selectedToken.isEth {
					return (GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
				}
				return selectedToken
			}

			firstly {
				try web3.getAllowanceOf(
					contractAddress: selectedAllowenceToken.id.lowercased(),
					spenderAddress: Web3Core.Constants.permitAddress,
					ownerAddress: walletManager.currentAccount.eip55Address
				)
			}.done { [self] allowanceAmount in
				let destTokenDecimal = selectedAllowenceToken.decimal
				let destTokenAmount = Utilities.parseToBigUInt(
					tokenAmount,
					decimals: destTokenDecimal
				)
				if allowanceAmount == 0 || allowanceAmount < destTokenAmount! {
					// NOT ALLOWED
					seal.fulfill((hasAllowance: false, selectedTokenId: selectedAllowenceToken.id))
				} else {
					// ALLOWED
					seal.fulfill((hasAllowance: true, selectedTokenId: selectedToken.id))
				}
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
