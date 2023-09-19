//
//  BorrowDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Combine
import Foundation

class BorrowLoanDetailsViewModel {
	// MARK: - Public Properties

	public let dismissIconName = "dissmiss"
	public let apyTitle = "APY"
	public let borrowedAmountTitle = "Borrowed amount"
	public let accuredFeeTitle = "Accured fee"
	public let totalDebtTitle = "Total debt"
	public let increaseLoanTitle = "Increase loan"
	public let repayTitle = "Repay"
	public let userBorrowedTokenModel: UserBorrowingToken
	public let borrowVM: BorrowViewModel

	public var pageTitle: String {
		"\(foundTokenInManageAssetTokens.symbol) loan details"
	}

	public var tokenIcon: URL {
		foundTokenInManageAssetTokens.image
	}

	public var tokenBorrowAmountAndSymbol: String {
		borrowedAmountBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	@Published
	public var apy: String? = nil
	public var apyVolatilityType: AssetVolatilityType?
	public var borrowedAmount: String {
		borrowedAmountBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var accuredFee: String {
		let accuredFee = totalDebtBigNumber - borrowedAmountBigNumber
		return accuredFee.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var totalDebt: String {
		totalDebtBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var foundTokenInManageAssetTokens: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userBorrowedTokenModel.id }))!
	}

	public var defaultUserBorrowedTokenModel: UserBorrowingToken {
		userBorrowedTokenModel
	}

	// MARK: - Private Properties

	private let errorFetchingToastMessage = "Error fetching token APY from server"
	private let borrowingAPIClient = BorrowingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	private var totalDebtBigNumber: BigNumber {
		BigNumber(number: userBorrowedTokenModel.totalDebt!, decimal: foundTokenInManageAssetTokens.decimal)
	}

	private var borrowedAmountBigNumber: BigNumber {
		BigNumber(number: userBorrowedTokenModel.amount, decimal: foundTokenInManageAssetTokens.decimal)
	}

	// MARK: - Initializers

	init(userBorrowedTokenModel: UserBorrowingToken, borrowVM: BorrowViewModel) {
		self.userBorrowedTokenModel = userBorrowedTokenModel
		self.borrowVM = borrowVM
	}

	// MARK: - Public Methods

	public func getBorrowableTokenProperties() {
		borrowingAPIClient.getBorrowableToken(dex: borrowVM.selectedDexSystem.type, tokenID: userBorrowedTokenModel.id)
			.sink { completed in
				switch completed {
				case .finished:
					print("borrowable token received successfully")
				case let .failure(error):
					print(error)
					Toast.default(
						title: self.errorFetchingToastMessage,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			} receiveValue: { borrowableToken in
				self.setupApyInfo(borrowableToken: borrowableToken)
			}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func setupApyInfo(borrowableToken: BorrowableTokenModel) {
		let bigNumberAPY = borrowableToken.apy.bigNumber
		apyVolatilityType = AssetVolatilityType(change24h: bigNumberAPY)
		apy = "%\(bigNumberAPY.percentFormat)"
	}
}
