//
//  BorrowViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//

import Combine

class BorrowViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedDexProtocol: dexProtocolModel = .aave
	@Published
	public var userBorrowingDetails: UserBorrowingModel? = nil

	public let dexProtocolsList: [dexProtocolModel] = [.aave, .compound]

	public let pageTitle = "Borrow"
	public let collateralTitle = "Collateral"
	public let collateralDescription = "Deposit assets as collateral to get started"
	public let borrowTitle = "Borrow"
	public let borrowDescription = "Now you can borrow assets"
	public let rightArrowImageName = "primary_right_arrow"
	public let healthScoreTitle = "Health Score"
	#warning("this tooltip is for testing and should be replaced")
	public let healthScoreTooltip = "this is health score"

	// MARK: - Private Properties

	#warning("this is mock")
	private let borrowAPIClient = BorrowAPIMockClient()
	private let walletManager = PinoWalletManager()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func getBorrowingDetailsFromVC() {
		#warning("we should add a timer to update borrowing data every 5 seconds")
		#warning("we should consider user address to prevent show some user details to all accounts")
		getUserBorrowingDetails()
	}

	// MARK: - Private Methods

	private func getUserBorrowingDetails() {
		borrowAPIClient.getUserBorrowings(
			address: walletManager.currentAccount.eip55Address,
			dex: selectedDexProtocol.type
		).sink { completed in
			switch completed {
			case .finished:
				print("User borrowing details received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { userBorrowingDetails in
			self.userBorrowingDetails = userBorrowingDetails
		}.store(in: &cancellables)
	}
}
