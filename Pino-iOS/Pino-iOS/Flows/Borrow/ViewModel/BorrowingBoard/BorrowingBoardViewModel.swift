//
//  BorrowingBoardViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Combine
import Foundation

class BorrowingBoardViewModel {
	// MARK: - Public Properties

	public let loansTitleText = "loans"
	public let errorFetchingToastMessage = "Failed to get borrowable tokens"

	public let borrowingAPIClient = BorrowingAPIClient()
	public var borrowVM: BorrowViewModel
	public var userBorrowingTokens: [UserBorrowingAssetViewModel]!
	@Published
	public var borrowableTokens: [BorrowableAssetViewModel]?
	public var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel) {
		self.borrowVM = borrowVM

		setUserBorrowedTokens()
	}

	// MARK: - Public Methods

	public func getBorrowableTokens() {
		borrowingAPIClient.getBorrowableTokens(dex: borrowVM.selectedDexSystem.type).sink { completed in
			switch completed {
			case .finished:
				print("Borrowable tokens received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { newBorrowableTokens in
			let filteredBorrowableTokens = newBorrowableTokens.filter { newBorrowableToken in
				self.borrowVM.userBorrowingDetails?.borrowTokens
					.first(where: { $0.id == newBorrowableToken.tokenID }) == nil
			}
			self.borrowableTokens = filteredBorrowableTokens.compactMap {
				BorrowableAssetViewModel(borrowableTokenModel: $0)
			}
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func setUserBorrowedTokens() {
		userBorrowingTokens = borrowVM.userBorrowingDetails?.borrowTokens.compactMap {
			UserBorrowingAssetViewModel(userBorrowingTokenModel: $0)
		}
	}
}
