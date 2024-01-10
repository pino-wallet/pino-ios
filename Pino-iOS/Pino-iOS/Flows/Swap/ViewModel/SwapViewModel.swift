//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation
import PromiseKit
import Web3_Utility

class SwapViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedProtocol: SwapProtocolModel
	@Published
	public var swapState: SwapState

	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let switchIcon = "arrow_down"

	public var fromToken: SwapTokenViewModel
	public var toToken: SwapTokenViewModel

	public var swapFeeVM: SwapFeeViewModel

	public var providers: [SwapProviderViewModel] = []
	public var bestProvider: SwapProviderViewModel?

	// MARK: - Private Properties

	private let priceManager = SwapPriceManager()
	private var web3 = Web3Core.shared
	private let walletManager = PinoWalletManager()

	private var swapSide: SwapSide? {
		if !fromToken.isEditing && !toToken.isEditing {
			return .sell
		} else if fromToken.isEditing {
			return .sell
		} else if toToken.isEditing {
			return .buy
		} else {
			return nil
		}
	}

	// MARK: - Initializers

	init(fromToken: AssetViewModel, toToken: AssetViewModel) {
		self.selectedProtocol = .bestRate
		self.fromToken = SwapTokenViewModel(selectedToken: fromToken)
		self.toToken = SwapTokenViewModel(selectedToken: toToken)
		self.swapFeeVM = SwapFeeViewModel()
		self.swapState = .initial

		self.fromToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.toToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Public Methods

	public func changeFromToken(to newToken: AssetViewModel) {
		fromToken.selectedToken = newToken
		switch swapState {
		case .hasAmount, .loading, .noQuote:
			recalculateTokensAmount()
		case .initial, .noToToken, .clear:
			break
		}
		recalculateTokensAmount()
		fromToken.swapDelegate.selectedTokenDidChange()
	}

	public func changeToToken(to newToken: AssetViewModel) {
		toToken.selectedToken = newToken
		switch swapState {
		case .initial:
			swapState = .clear
		case .noToToken:
			swapState = .loading
			recalculateTokensAmount()
		case .hasAmount, .loading, .noQuote:
			recalculateTokensAmount()
		case .clear:
			break
		}
		toToken.swapDelegate.selectedTokenDidChange()
	}

	public func switchTokens() {
		let selectedFromToken = fromToken.selectedToken
		fromToken.selectedToken = toToken.selectedToken
		toToken.selectedToken = selectedFromToken

		let fromTokenAmount = fromToken.tokenAmount
		fromToken.tokenAmount = toToken.tokenAmount
		toToken.tokenAmount = fromTokenAmount

		recalculateTokensAmount()

		fromToken.swapDelegate.selectedTokenDidChange()
		toToken.swapDelegate.selectedTokenDidChange()
	}

	public func changeSwapProtocol(to swapProtocol: SwapProtocolModel) {
		selectedProtocol = swapProtocol
		recalculateTokensAmount()
	}

	public func changeSwapProvider(to swapProvider: SwapProviderViewModel) {
		getSwapSide { side, srcToken, destToken in
			swapFeeVM.swapProviderVM = swapProvider
			updateDestinationToken(destToken: destToken, tokenAmount: swapProvider.formattedSwapAmount)
			getFeeInfo(swapProvider: swapProvider)
		}
	}

	public func getSwapSide(
		completion: (_ side: SwapSide, _ srcToken: SwapTokenViewModel, _ destToken: SwapTokenViewModel) -> Void
	) {
		guard let swapSide else { return }
		switch swapSide {
		case .sell:
			completion(.sell, fromToken, toToken)
		case .buy:
			completion(.buy, toToken, fromToken)
		}
	}

	public func showConfirmOrApprovePage(_ showApprovePage: @escaping (Bool) -> Void) {
		if fromToken.selectedToken.isEth {
			showApprovePage(false)
			return
		}

		firstly {
			try web3.getAllowanceOf(
				contractAddress: fromToken.selectedToken.id.lowercased(),
				spenderAddress: Web3Core.Constants.permitAddress,
				ownerAddress: walletManager.currentAccount.eip55Address
			)
		}.done { [self] allowanceAmount in
			let destTokenDecimal = fromToken.selectedToken.decimal
			let destTokenAmount = Utilities.parseToBigUInt(fromToken.tokenAmount!, decimals: destTokenDecimal)
			if allowanceAmount == 0 || allowanceAmount < destTokenAmount! {
				// NOT ALLOWED
				showApprovePage(true)
			} else {
				// ALLOWED
				showApprovePage(false)
			}
		}.catch { error in
			print(error)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String?) {
		getSwapSide { side, srcToken, destToken in
			getSwapAmount(srcToken: srcToken, destToken: destToken, amount: amount, swapSide: side)
		}
	}

	private func recalculateTokensAmount() {
		getSwapSide { side, srcToken, destToken in
			getSwapAmount(srcToken: srcToken, destToken: destToken, amount: srcToken.tokenAmount, swapSide: side)
		}
	}

	private func getSwapAmount(
		srcToken: SwapTokenViewModel,
		destToken: SwapTokenViewModel,
		amount: String?,
		swapSide: SwapSide
	) {
		if let amount {
			if amount.last == "." { return }
		}
		srcToken.calculateDollarAmount(amount)
		if isEthToWeth() || isWethToEth() {
			updateEthSwapInfo(destToken: destToken, amount: amount)
		} else if let tokenAmount = srcToken.tokenAmount,
		          let swapAmount = Utilities.parseToBigUInt(tokenAmount, units: .custom(srcToken.selectedToken.decimal)),
		          !swapAmount.isZero {
			getDestinationAmount(destToken, swapAmount: swapAmount.description, swapSide: swapSide)
		} else {
			removeDestinationAmount(destToken)
		}
	}

	private func getDestinationAmount(_ destToken: SwapTokenViewModel, swapAmount: String, swapSide: SwapSide) {
		switch swapState {
		case .initial:
			swapState = .noToToken
		case .noToToken:
			break
		case .clear, .hasAmount, .loading, .noQuote:
			swapState = .loading
			removePreviousFeeInfo()
			destToken.swapDelegate.swapAmountCalculating()
			getSwapProviderInfo(
				destToken: destToken.selectedToken,
				amount: swapAmount,
				swapSide: swapSide
			) { swapAmount in
				self.updateDestinationToken(destToken: destToken, tokenAmount: swapAmount)
				if swapAmount == nil {
					self.swapState = .noQuote
				} else {
					self.swapState = .hasAmount
				}
			}
		}
	}

	private func removeDestinationAmount(_ destToken: SwapTokenViewModel) {
		switch swapState {
		case .initial, .clear:
			break
		case .noToToken:
			if fromToken.tokenAmount == nil {
				swapState = .initial
			} else {
				break
			}
		case .hasAmount, .loading, .noQuote:
			swapState = .clear
		}
		priceManager.cancelPreviousRequests()
		updateDestinationToken(destToken: destToken, tokenAmount: nil)
		getFeeInfo(swapProvider: nil)
	}

	private func getSwapProviderInfo(
		destToken: AssetViewModel,
		amount: String,
		swapSide: SwapSide,
		completion: @escaping (String?) -> Void
	) {
		if selectedProtocol == .bestRate {
			getBestRate(destToken: destToken, amount: amount, swapSide: swapSide, completion: completion)
		} else {
			#warning("The price of other protocols must be taken here")
		}
	}

	private func getBestRate(
		destToken: AssetViewModel,
		amount: String,
		swapSide: SwapSide,
		completion: @escaping (String?) -> Void
	) {
		priceManager.getBestPrice(srcToken: fromToken, destToken: toToken, swapSide: swapSide, amount: amount)
			{ providersInfo in
				if providersInfo.isEmpty {
					completion(nil)
				} else {
					self.providers = providersInfo.compactMap {
						SwapProviderViewModel(providerResponseInfo: $0, side: swapSide, destToken: destToken)
					}.sorted { $0.swapAmount > $1.swapAmount }
					let bestProvider = self.providers.first!
					self.bestProvider = bestProvider
					completion(bestProvider.formattedSwapAmount)
					self.getFeeInfo(swapProvider: bestProvider)
				}
			}
	}

	private func updateDestinationToken(destToken: SwapTokenViewModel, tokenAmount: String?) {
		destToken.calculateDollarAmount(tokenAmount)
		destToken.swapDelegate.swapAmountDidCalculate()
	}

	private func getFeeInfo(swapProvider: SwapProviderViewModel?) {
		swapFeeVM.updateQuote(srcToken: fromToken, destToken: toToken)
		guard let swapProvider else { return }
		swapFeeVM.swapProviderVM = swapProvider
		updateBestRateTag()
		if fromToken.selectedToken.isVerified && toToken.selectedToken.isVerified {
			swapFeeVM.calculatePriceImpact(
				srcTokenAmount: fromToken.decimalDollarAmount,
				destTokenAmount: toToken.decimalDollarAmount
			)
		}
	}

	private func removePreviousFeeInfo() {
		swapFeeVM.calculatedAmount = .emptyString
		swapFeeVM.priceImpact = nil
	}

	private func getFeeTag(saveAmount: String) -> SwapFeeViewModel.FeeTag {
		if BigNumber(numberWithDecimal: saveAmount) > BigNumber(number: 0, decimal: 0) {
			return .save("\(saveAmount.currencyFormatting) \(swapFeeVM.celebrateEmoji)")
		} else {
			return .none
		}
	}

	private func getFeeTag(priceImpact: String) -> SwapFeeViewModel.FeeTag {
		if BigNumber(numberWithDecimal: priceImpact) > BigNumber(number: 1, decimal: 0) {
			return .highImpact
		} else {
			return .none
		}
	}

	private func updateBestRateTag() {
		if swapFeeVM.swapProviderVM?.provider == bestProvider?.provider {
			swapFeeVM.isBestRate = true
		} else {
			swapFeeVM.isBestRate = false
		}
	}

	private func updateEthSwapInfo(destToken: SwapTokenViewModel, amount: String?) {
		updateDestinationToken(destToken: destToken, tokenAmount: amount)
		swapFeeVM.swapProviderVM = nil
		swapFeeVM.updateQuote(srcToken: fromToken, destToken: toToken)
		if fromToken.selectedToken.isVerified && toToken.selectedToken.isVerified {
			swapFeeVM.calculatePriceImpact(
				srcTokenAmount: fromToken.decimalDollarAmount,
				destTokenAmount: toToken.decimalDollarAmount
			)
		}
	}

	private func isEthToWeth() -> Bool {
		fromToken.selectedToken.isEth && toToken.selectedToken.isWEth
	}

	private func isWethToEth() -> Bool {
		fromToken.selectedToken.isWEth && toToken.selectedToken.isEth
	}
}

public enum SwapState {
	case initial
	case clear
	case hasAmount
	case loading
	case noQuote
	case noToToken
}
