//
//  WithdrawAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Combine
import Foundation
import PromiseKit
import Web3_Utility

class WithdrawAmountViewModel {
	// MARK: - TypeAliases

	typealias AllowanceDataType = (hasAllowance: Bool, selectedPositionTokenID: String)

	// MARK: - Public Properties

	public let pageTitleWithdrawText = "Withdraw"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Withdraw"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"
	public let failedToGetApproveDataErrorText = "Failed to get approve data"

	public let userCollateralledTokenID: String
	public let borrowVM: BorrowViewModel
	public var userCollateralledTokenModel: UserBorrowingToken!

	public var selectedToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userCollateralledTokenModel.id }))!
	}

	public var aavePositionToken: AssetViewModel?

	public var tokenAmount = "0"
	public var dollarAmount: String = .emptyString
	// This is max of user collateralled free amount
	public var maxWithdrawAmount: BigNumber {
		let avarageLTV = borrowVM.totalCollateralAmountsInDollar.totalBorrowableAmountInDollars / borrowVM
			.totalCollateralAmountsInDollar.totalAmountInDollars
		let amountNeedToCoverBorrowInDollars = (borrowVM.totalBorrowAmountInDollars / avarageLTV!)!
		let collateralledTokenAmountInDollars = BigNumber(
			number: userCollateralledTokenModel.amount,
			decimal: selectedToken.decimal
		) * selectedToken.price
		let maxWithdrawAmountInDollars = min(
			borrowVM.totalCollateralAmountsInDollar.totalAmountInDollars - amountNeedToCoverBorrowInDollars,
			collateralledTokenAmountInDollars
		)
		return (maxWithdrawAmountInDollars / selectedToken.price)!
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxWithdrawAmount: String {
		maxWithdrawAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var maxWithdrawAmountInDollars: String {
		maxWithdrawAmount.priceFormat
	}

	public var prevHealthScore: BigNumber {
		calculateCurrentHealthScore()
	}

	public var newHealthScore: BigNumber = 0.bigNumber

	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private let walletManager = PinoWalletManager()
	private let borrowingAPIClient = BorrowingAPIClient()
	private let borrowingHelper = BorrowingHelper()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel, userCollateralledTokenID: String) {
		self.userCollateralledTokenID = userCollateralledTokenID
		self.borrowVM = borrowVM

		setUserCollateralledToken()
	}

	// MARK: - Private Methods

	private func calculateCurrentHealthScore() -> BigNumber {
		borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: borrowVM.totalBorrowAmountInDollars,
			totalBorrowableAmountForHealthScore: borrowVM.totalCollateralAmountsInDollar
				.totalBorrowableAmountInDollars
		)
	}

	private func calculateNewHealthScore(dollarAmount: BigNumber) -> BigNumber {
		let tokenLQ = borrowVM.getCollateralizableTokenLQ(tokenID: selectedToken.id)
		let totalBorrowableAmountForHealthScore = borrowVM.totalCollateralAmountsInDollar
			.totalBorrowableAmountInDollars - ((dollarAmount / 100.bigNumber)! * (tokenLQ / 100.bigNumber)!)
		return borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: borrowVM.totalBorrowAmountInDollars,
			totalBorrowableAmountForHealthScore: totalBorrowableAmountForHealthScore
		)
	}

	private func setUserCollateralledToken() {
		userCollateralledTokenModel = borrowVM.userBorrowingDetails?.collateralTokens
			.first(where: { $0.id == userCollateralledTokenID })
	}

	private func getPositionTokenID() -> Promise<String> {
		Promise<String> { seal in
			borrowingAPIClient.getPositionTokenId(
				underlyingTokenId: selectedToken.id,
				tokenProtocol: borrowVM.selectedDexSystem.type,
				positionType: .investment
			).sink { _ in
			} receiveValue: { positionTokenDetails in
				seal.fulfill(positionTokenDetails.positionID)
			}.store(in: &cancellables)
		}
	}

	private func checkTokenAllowancePermit2(selectedAllowenceToken: AssetViewModel) -> Promise<Bool> {
		Promise<Bool> { seal in
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
					seal.fulfill(false)
				} else {
					// ALLOWED
					seal.fulfill(true)
				}
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func checkTokenAllowanceForPermit2() -> Promise<AllowanceDataType> {
		Promise<AllowanceDataType> { seal in
			firstly {
				getPositionTokenID()
			}.then { positionTokenID -> Promise<(AssetViewModel, Bool)> in
				let selectedAllowenceToken = (
					GlobalVariables.shared.manageAssetsList?
						.first(where: { $0.id.lowercased() == positionTokenID.lowercased() })
				)!
				return self.checkTokenAllowancePermit2(selectedAllowenceToken: selectedAllowenceToken)
					.map { (selectedAllowenceToken, $0) }
			}.done { selectedAllowenceToken, hasAllowance in
				self.aavePositionToken = selectedAllowenceToken
				seal.fulfill((hasAllowance: hasAllowance, selectedPositionTokenID: selectedAllowenceToken.id))

			}.catch { error in
				seal.reject(error)
			}
		}
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
			newHealthScore = calculateNewHealthScore(dollarAmount: amountInDollarDecimalValue)
			dollarAmount = amountInDollarDecimalValue.priceFormat
		} else {
			newHealthScore = calculateCurrentHealthScore()
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
			if BigNumber(numberWithDecimal: tokenAmount) > maxWithdrawAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

	public func checkTokenAllowance() -> Promise<AllowanceDataType> {
		Promise<AllowanceDataType> { seal in
			switch borrowVM.selectedDexSystem {
			case .aave:
				checkTokenAllowanceForPermit2().done { allowanceData in
					seal.fulfill(allowanceData)
				}.catch { error in
					seal.reject(error)
				}
			case .compound:
				checkTokenAllowanceForPermit2().done { allowanceData in
					seal.fulfill(allowanceData)
				}.catch { error in
					seal.reject(error)
				}
			default:
				fatalError("Unknown selected dex system")
			}
		}
	}
}
