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

	public var globalAssetsList: [AssetViewModel]?
	public let alertIconName = "alert"
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
	public let errorFetchingToastMessage = "Error fetching borrowing data from server"
	public let borrowProgressBarColor = UIColor.Pino.primary
	public let collateralProgressBarColor = UIColor.Pino.succesGreen2

	// MARK: - Private Properties

	private let borrowAPIClient = BorrowingAPIClient()
	private let walletManager = PinoWalletManager()
	private var requestTimer: Timer?
	private var currentUserAddress: String?
	private var userBorrowingDetailsCache: UserBorrowingModel?
	private var cancellables = Set<AnyCancellable>()
	private var globalAssetsListCancellable = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func getBorrowingDetailsFromVC() {
		if walletManager.currentAccount.eip55Address != currentUserAddress {
			destroyData()
		}
		currentUserAddress = walletManager.currentAccount.eip55Address
		setupRequestTimer()
		requestTimer?.fire()
		if globalAssetsList == nil {
			setupBindings()
		}
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
		userBorrowingDetailsCache = nil
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(getUserBorrowingDetails),
			userInfo: nil,
			repeats: true
		)
	}

	private func setupBindings() {
		GlobalVariables.shared.$manageAssetsList.sink { manageAssetsList in
			if self.userBorrowingDetailsCache != nil && manageAssetsList != nil {
				self.globalAssetsList = manageAssetsList
				self.userBorrowingDetails = self.userBorrowingDetailsCache
			}
			self.globalAssetsListCancellable.removeAll()
		}.store(in: &globalAssetsListCancellable)
	}

	@objc
	private func getUserBorrowingDetails() {
        #warning("this address is for testing")
		borrowAPIClient.getUserBorrowings(
			address: "0xc029F24C043D9b44e0b4506485FfC61013f1B1F2",
			dex: selectedDexSystem.type
		).sink { completed in
			switch completed {
			case .finished:
				print("User borrowing details received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { userBorrowingDetails in
			if GlobalVariables.shared.manageAssetsList == nil {
				self.userBorrowingDetailsCache = userBorrowingDetails
			} else {
				self.globalAssetsList = GlobalVariables.shared.manageAssetsList
				self.userBorrowingDetails = userBorrowingDetails
			}
		}.store(in: &cancellables)
	}
}
