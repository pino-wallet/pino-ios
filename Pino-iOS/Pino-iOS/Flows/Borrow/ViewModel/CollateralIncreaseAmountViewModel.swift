//
//  CollateralIncreaseAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Combine
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
	public let loadingButtonTitle = "Please wait"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"
	private let feeTxErrorText = "Failed to estimate fee of transaction"

	public let selectedToken: AssetViewModel
	public let borrowVM: BorrowViewModel
	public let collateralMode: CollateralMode

	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var maxHoldAmount: BigNumber?
	@Published
	public var collateralPageStatus: CollateralPageStatus = .loading

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxHoldAmount: String {
		guard let maxHoldAmount, maxHoldAmount.number.sign != .minus else {
			return "0".tokenFormatting(token: selectedToken.symbol)
		}
		return maxHoldAmount.plainSevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var maxAmountInDollars: String {
		selectedToken.holdAmountInDollor.priceFormat
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var positionErrorText: String {
		"You have an open \(selectedToken.symbol) investment position in \(borrowVM.selectedDexSystem.name), which you need to close before depositing \(selectedToken.symbol) as collateral."
	}

	#warning("this is mock")
	public var prevHealthScore: Double = 0
	public var newHealthScore: Double = 24

	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private let defaultTokenAmount = "1"
	private let walletManager = PinoWalletManager()
	private let borrowingAPIClient = BorrowingAPIClient()
	private var requestTimer: Timer?
	private var cancellables = Set<AnyCancellable>()

	private lazy var aaveCollateralManager: AaveCollateralManager = {
		let pinoAaveProxyContract = try! web3.getPinoAaveProxyContract()
		return AaveCollateralManager(
			contract: pinoAaveProxyContract,
			asset: selectedToken,
			assetAmount: defaultTokenAmount
		)
	}()

	#warning("i should add compoundCollateralManager here")

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, borrowVM: BorrowViewModel, collateralMode: CollateralMode) {
		self.selectedToken = selectedToken
		self.borrowVM = borrowVM
		self.collateralMode = collateralMode
	}

	// MARK: - Private Methods

	private func calculateAaveCollateralETHMaxAmount() {
		aaveCollateralManager.getETHCollateralData().done { collateralData in
			let collateralFee = collateralData.1.fee
			let maxHoldAmountBigNumber = self.selectedToken.holdAmount - collateralFee
			if maxHoldAmountBigNumber.number.sign == .minus {
				self.maxHoldAmount = 0.bigNumber
			} else {
				self.maxHoldAmount = maxHoldAmountBigNumber
			}
			self.checkAmountStatus(amount: self.tokenAmount)
		}.catch { error in
			print("heh", error)
			self.collateralPageStatus = .loading
			Toast.default(
				title: self.feeTxErrorText,
				subtitle: GlobalToastTitles.tryAgainToastTitle.message,
				style: .error
			)
			.show(haptic: .warning)
		}
	}

	#warning("i should create setCompoundCollateralETHMaxAmount too")

	private func checkForOpenPositionToken() -> Promise<Bool> {
		Promise<Bool> { seal in
			borrowingAPIClient.getPositionTokenId(
				underlyingTokenId: selectedToken.id,
				tokenProtocol: borrowVM.selectedDexSystem.type,
				positionType: .investment
			).sink { completed in
				switch completed {
				case .finished:
					print("Collateralizable tokens received successfully")
				case let .failure(error):
					seal.reject(error)
					Toast.default(
						title: self.feeTxErrorText,
						subtitle: GlobalToastTitles.tryAgainToastTitle.message,
						style: .error
					)
					.show(haptic: .warning)
				}
			} receiveValue: { positionTokenID in
				let positionToken = self.borrowVM.globalAssetsList?
					.first(where: { $0.id == positionTokenID.positionID })
				if positionToken != nil {
					if let positionTokenAmount = positionToken?.holdAmount, !positionTokenAmount.isZero {
						seal.fulfill(true)
					} else {
						seal.fulfill(false)
					}
				} else {
					seal.fulfill(false)
				}
			}.store(in: &cancellables)
		}
	}

	private func calculateETHFeeAave() {
		switch collateralMode {
		case .increase:
			calculateAaveCollateralETHMaxAmount()
		case .create:
			checkForOpenPositionToken().done { isOpenPosition in
				if isOpenPosition {
					self.collateralPageStatus = .openPositionError
					self.destroyRequestTimer()
				} else {
					self.calculateAaveCollateralETHMaxAmount()
				}
			}.catch { error in
				print(error)
			}
		}
	}

	private func calculateETHFeeCompound() {
		#warning("i should add it later")
	}

	private func setMaxHoldAmount() {
		maxHoldAmount = selectedToken.holdAmount
		collateralPageStatus = .normal
		destroyRequestTimer()
	}

	@objc
	private func calculateMaxHoldAmount() {
		if selectedToken.isEth {
			switch borrowVM.selectedDexSystem {
			case .aave:
				calculateETHFeeAave()
			case .compound:
				calculateETHFeeCompound()
			default:
				fatalError("unknown dex type")
			}
		} else {
			switch collateralMode {
			case .increase:
				setMaxHoldAmount()
			case .create:
				checkForOpenPositionToken().done { isOpenPosition in
					if isOpenPosition {
						self.collateralPageStatus = .openPositionError
						self.destroyRequestTimer()
					} else {
						self.setMaxHoldAmount()
					}
				}.catch { error in
					print(error)
				}
			}
		}
	}

	// MARK: - Public Methods

	public func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(calculateMaxHoldAmount),
			userInfo: nil,
			repeats: true
		)
		requestTimer?.fire()
	}

	public func destroyRequestTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

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

	public func checkAmountStatus(amount: String) {
		guard let maxHoldAmount else {
			collateralPageStatus = .loading
			return
		}
		guard collateralPageStatus != .openPositionError else {
			return
		}
		if amount == .emptyString {
			collateralPageStatus = .isZero
		} else if BigNumber(numberWithDecimal: amount).isZero {
			collateralPageStatus = .isZero
		} else {
			if BigNumber(numberWithDecimal: tokenAmount) > maxHoldAmount {
				collateralPageStatus = .isNotEnough
			} else {
				collateralPageStatus = .normal
			}
		}
	}

	public func checkTokenAllowance() -> Promise<AllowanceDataType> {
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
