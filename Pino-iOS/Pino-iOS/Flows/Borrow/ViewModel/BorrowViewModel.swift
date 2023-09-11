//
//  BorrowViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//
import Combine
import UIKit

class BorrowViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedDexSystem: DexSystemModel = .aave
	@Published
	public var userBorrowingDetails: UserBorrowingModel? = nil

	public let dismissIconName = "dissmiss"
	public let pageTitle = "Borrow"
	public let collateralTitle = "Collateral"
	public let collateralDescription = "Deposit assets as collateral to get started"
	public let borrowTitle = "Borrow"
	public let borrowDescription = "Now you can borrow assets"
	public let rightArrowImageName = "primary_right_arrow"
	public let healthScoreTitle = "Health Score"
	#warning("this tooltip is for testing and should be replaced")
	public let healthScoreTooltip = "this is health score"
	public let borrowProgressBarColor = UIColor.Pino.primary
	public let collateralProgressBarColor = UIColor.Pino.succesGreen2

	// MARK: - Private Properties

	private let borrowAPIClient = BorrowingAPIClient()
	private let walletManager = PinoWalletManager()
    private var requestTimer: Timer? = nil
    private var currentUserAddress: String? = nil
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func getBorrowingDetailsFromVC() {
        if walletManager.currentAccount.eip55Address != currentUserAddress {
            destroyData()
        }
        currentUserAddress = walletManager.currentAccount.eip55Address
        setupRequestTimer()
        requestTimer?.fire()
	}

	public func changeSelectedDexSystem(newSelectedDexSystem: DexSystemModel) {
        if selectedDexSystem != newSelectedDexSystem {
            destroyData()
            selectedDexSystem = newSelectedDexSystem
            requestTimer?.fire()
        } else {
            selectedDexSystem = newSelectedDexSystem
        }
	}
    
    public func destroyRequestTimer() {
        requestTimer?.invalidate()
        requestTimer = nil
    }
    

	// MARK: - Private Methods
    
    private func destroyData() {
        userBorrowingDetails = nil
    }
    
    private func setupRequestTimer() {
        requestTimer =  Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getUserBorrowingDetails), userInfo: nil, repeats: true)
    }

	@objc private func getUserBorrowingDetails() {
		borrowAPIClient.getUserBorrowings(
			address: walletManager.currentAccount.eip55Address,
			dex: selectedDexSystem.type
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
