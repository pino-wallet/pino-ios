//
//  CollateralizingBoardViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Combine
import Foundation

class CollateralizingBoardViewModel {
	// MARK: - Public Properties

	public let collateralsTitleText = "collaterals"
	public let borrowVM: BorrowViewModel
	public var userCollateralizingTokens: [UserCollateralizingAssetViewModel]!
	@Published
	public var collateralizableTokens: [CollateralizableAssetViewModel]?

	// MARK: - Private Properties

	private let errorFetchingToastMessage = "Failed to get collateralizable tokens"
	private let borrowingAPIClient = BorrowingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		borrowVM: BorrowViewModel
	) {
		self.borrowVM = borrowVM

		setUserCollateralizingTokens()
	}

	// MARK: - Public Methods

	public func getCollaterlizableTokens() {
		borrowingAPIClient.getCollateralizableTokens(dex: borrowVM.selectedDexSystem.type).sink { completed in
			switch completed {
			case .finished:
				print("Collateralizable tokens received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				).show(haptic: .warning)
			}
		} receiveValue: { newCollateralizableTokens in
			let filteredCollateralizableTokens = newCollateralizableTokens.filter { newCollateralizableToken in
				self.borrowVM.userBorrowingDetails?.collateralTokens
					.first(where: { $0.id == newCollateralizableToken.tokenID }) == nil
			}
			self.collateralizableTokens = filteredCollateralizableTokens.compactMap {
				CollateralizableAssetViewModel(collateralizableAssetModel: $0)
			}
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func setUserCollateralizingTokens() {
		userCollateralizingTokens = borrowVM.userBorrowingDetails?.collateralTokens.compactMap {
			UserCollateralizingAssetViewModel(userCollateralizingAssetModel: $0)
		}
	}
}
