//
//  BorrowViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//
import Combine
import UIKit

class BorrowViewModel {
	// MARK: - TypeAliases

	typealias TotalCollateralAmountsInDollarType = (
		totalAmountInDollars: BigNumber,
		totalBorrowableAmountInDollars: BigNumber
	)

	// MARK: - Public Properties

	@Published
	public var selectedDexSystem: DexSystemModel = .aave
	@Published
	public var userBorrowingDetails: UserBorrowingModel? = nil

	public var totalCollateralAmountsInDollar: TotalCollateralAmountsInDollarType {
		var totalAmountInDollars = 0.bigNumber
		var totalBorrowableAmountInDollars = 0.bigNumber
		guard let collateralledTokens = userBorrowingDetails?.collateralTokens, let collateralizableTokens else {
			fatalError("Collateraled tokens or collateralizable tokens is nil")
		}
		for collateraledToken in collateralledTokens {
			guard let foundTokenInGlobalTokens = globalAssetsList?.first(where: { $0.id == collateraledToken.id })
			else {
				fatalError("Collateralled token not found in global tokens list")
			}
			guard let tokenLTV = collateralizableTokens.first(where: { $0.tokenID == collateraledToken.id })?.ltv else {
				fatalError("Liquidation treshold of collateralled token is nil")
			}
			let calculatedTokenLTV = (tokenLTV / 100)
			let tokenTotalAmountInDollars = BigNumber(
				number: collateraledToken.amount,
				decimal: foundTokenInGlobalTokens.decimal
			) * foundTokenInGlobalTokens.price
			totalAmountInDollars = totalAmountInDollars + tokenTotalAmountInDollars
			totalBorrowableAmountInDollars = (tokenTotalAmountInDollars / 100.bigNumber)! * calculatedTokenLTV.bigNumber
		}
		return (
			totalAmountInDollars: totalAmountInDollars,
			totalBorrowableAmountInDollars: totalBorrowableAmountInDollars
		)
	}

	public var totalBorrowAmountInDollars: BigNumber {
		var totalBorrowedAmountInDollars = 0.bigNumber
		guard let borrowedTokens = userBorrowingDetails?.borrowTokens else {
			fatalError("User borrowed tokens list is nil")
		}
		for borrowedToken in borrowedTokens {
			guard let foundTokenInGlobalTokens = globalAssetsList?.first(where: { $0.id == borrowedToken.id }) else {
				fatalError("Borrowed token not found in global tokens list")
			}
			let tokenBorrowedAmountInDollars = BigNumber(
				number: borrowedToken.amount,
				decimal: foundTokenInGlobalTokens.decimal
			) * foundTokenInGlobalTokens.price
			totalBorrowedAmountInDollars = totalBorrowedAmountInDollars + tokenBorrowedAmountInDollars
		}
		return totalBorrowedAmountInDollars
	}

	public var globalAssetsList: [AssetViewModel]?
	public var collateralizableTokens: CollateralizableTokensModel?
	public var calculatedHealthScore: Double = 0
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
		getCollateralizableTokens()
		if globalAssetsList == nil {
			setupBindings()
		}
	}

	public func changeSelectedDexSystem(newSelectedDexSystem: DexSystemModel) {
		if selectedDexSystem != newSelectedDexSystem {
			destroyData()
			selectedDexSystem = newSelectedDexSystem
			getCollateralizableTokens()
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
		collateralizableTokens = nil
		userBorrowingDetailsCache = nil
		userBorrowingDetails = nil
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
		GlobalVariables.shared.$manageAssetsList.compactMap { $0 }.sink { manageAssetsList in
			if self.userBorrowingDetailsCache != nil {
				self.globalAssetsList = manageAssetsList
				self.calculateHealthScore(currentUserBorrowingDetails: self.userBorrowingDetailsCache!)
				self.userBorrowingDetails = self.userBorrowingDetailsCache
			}
			self.globalAssetsListCancellable.removeAll()
		}.store(in: &globalAssetsListCancellable)
	}

	private func calculateHealthScore(currentUserBorrowingDetails: UserBorrowingModel) {
		calculatedHealthScore = currentUserBorrowingDetails.healthScore / 100
	}

	private func getCollateralizableTokens() {
		borrowAPIClient.getCollateralizableTokens(dex: selectedDexSystem.type).sink { completed in
			switch completed {
			case .finished:
				print("Collateralizable tokens received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { collateralizabletokens in
			self.collateralizableTokens = collateralizabletokens
			self.requestTimer?.fire()
		}.store(in: &cancellables)
	}

	@objc
	private func getUserBorrowingDetails() {
		if collateralizableTokens != nil {
			borrowAPIClient.getUserBorrowings(
				address: "0xC6778747F3b685c2FD6Fa5d3883FaDdF37874959",
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
					self.calculateHealthScore(currentUserBorrowingDetails: userBorrowingDetails)
					self.userBorrowingDetails = userBorrowingDetails
				}
			}.store(in: &cancellables)
		} else {
			getCollateralizableTokens()
		}
	}
}
