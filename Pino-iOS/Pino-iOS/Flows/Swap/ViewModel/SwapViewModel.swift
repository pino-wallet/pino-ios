//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation

class SwapViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedProtocol: SwapProtocolModel

	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let switchIcon = "switch_swap"

	public var fromToken: SwapTokenViewModel
	public var toToken: SwapTokenViewModel

	public var swapFeeVM: SwapFeeViewModel

	public var swapSide: SwapSide = .sell

	// MARK: - Private Properties

    private let paraSwapAPIClient = ParaSwapAPIClient()
    private let oneInchAPIClient = OneInchAPIClient()
    private let zeroXAPIClient = ZeroXAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(fromToken: AssetViewModel, toToken: AssetViewModel) {
		self.selectedProtocol = .bestRate
		self.fromToken = SwapTokenViewModel(selectedToken: fromToken)
		self.toToken = SwapTokenViewModel(selectedToken: toToken)
		self.swapFeeVM = SwapFeeViewModel()

		self.fromToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.toToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {
		token.selectedToken = newToken
		recalculateTokensAmount()
		token.swapDelegate.selectedTokenDidChange()
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
		if swapProtocol == .bestRate {
			swapFeeVM.swapProviderVM = getBestProvider()
		}
		recalculateTokensAmount()
	}

	public func changeSwapProvider(to swapProvider: SwapProviderViewModel) {
		swapFeeVM.swapProviderVM = swapProvider
		recalculateTokensAmount()
	}

	// MARK: - Private Methods
    
    private func recalculateTokensAmount(amount: String? = nil) {
        if !fromToken.isEditing && !toToken.isEditing {
            getSellAmount(amount: amount)
        } else if fromToken.isEditing {
            getSellAmount(amount: amount)
        } else if toToken.isEditing {
            getBuyAmount(amount: amount)
        }
        
        swapFeeVM.updateAmount(fromToken: fromToken, toToken: toToken)
        if amount != .emptyString {
            getFeeInfo()
        }
    }
    
    private func getSellAmount(amount: String?) {
        swapSide = .sell
        fromToken.calculateDollarAmount(amount)
        if fromToken.tokenAmount == nil {
            toToken.setAmount(tokenAmount: nil, dollarAmount: nil)
            toToken.swapDelegate.swapAmountDidCalculate()
        } else {
            toToken.swapDelegate.swapAmountCalculating()
            getSwapPrice(swapProviderAPIClient: paraSwapAPIClient) { destinationAmount in
                self.toToken.setAmount(tokenAmount: destinationAmount, dollarAmount: self.fromToken.dollarAmount)
                self.toToken.swapDelegate.swapAmountDidCalculate()
            }
        }
    }
    
    private func getBuyAmount(amount: String?) {
        swapSide = .buy
        toToken.calculateDollarAmount(amount)
        fromToken.calculateTokenAmount(decimalDollarAmount: toToken.decimalDollarAmount)
        if toToken.tokenAmount == nil {
            fromToken.swapDelegate.swapAmountDidCalculate()
        } else {
            fromToken.swapDelegate.swapAmountCalculating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.fromToken.swapDelegate.swapAmountDidCalculate()
            }
        }
    }
    
    private func getFeeInfo() {
        swapFeeVM.fee = nil
        swapFeeVM.feeInDollar = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.selectedProtocol == .bestRate {
                self.showBestProviderFeeInfo()
            } else {
                self.showPriceImpactFeeInfo()
            }
            self.swapFeeVM.fee = self.getfee().fee
            self.swapFeeVM.feeInDollar = self.getfee().feeInDollar
        }
    }
    
    private func getSwapPrice(swapProviderAPIClient: some SwapProvidersAPIServices, completion: @escaping (String) -> ()) {
        let swapInfo = SwapPriceRequestModel(
            srcToken: fromToken.selectedToken.id,
            srcDecimals: fromToken.selectedToken.decimal,
            destToken: toToken.selectedToken.id,
            destDecimals: toToken.selectedToken.decimal,
            amount: "1000000000000000000",
            side: .sell
        )
        
        swapProviderAPIClient.swapPrice(swapInfo: swapInfo).sink { completed in
            switch completed {
            case .finished:
                print("Swap price received successfully")
            case let .failure(error):
                print(error)
            }
        } receiveValue: { response in
            print(response)
            if let paraswapResponse = response as? ParaSwapPriceResponseModel {
                completion(paraswapResponse.priceRoute.destAmount)
            }
        }.store(in: &cancellables)
    }

	private func showBestProviderFeeInfo() {
		swapFeeVM.feeTag = .none
		swapFeeVM.priceImpact = nil
		if swapFeeVM.swapProviderVM == nil {
			swapFeeVM.swapProviderVM = getBestProvider()
		}
	}

	private func showPriceImpactFeeInfo() {
		let priceImpact = getPriceImpact()
		swapFeeVM.priceImpact = priceImpact
		swapFeeVM.feeTag = getFeeTag(priceImpact: priceImpact)
		swapFeeVM.swapProviderVM = nil
		swapFeeVM.saveAmount = nil
	}

	#warning("These values are temporary and must be replaced with network data")

	private func getBestProvider() -> SwapProviderViewModel {
		SwapProviderViewModel(provider: .oneInch, swapAmount: "")
	}

	private func getfee() -> (fee: String, feeInDollar: String) {
		let fee = "0.001"
		let feeInDollar = "1.12"
		return (fee.ethFormatting, feeInDollar.currencyFormatting)
	}

	private func getSaveAmount() -> String {
		"1"
	}

	private func getPriceImpact() -> String {
		"2"
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
}
