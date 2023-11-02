//
//  SwapConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3_Utility

class SwapConfirmationViewModel {
	// MARK: - Private Properties

	private let selectedProtocol: SwapProtocolModel
	private let selectedProvider: SwapProviderViewModel?
	private let web3 = Web3Core.shared
	private let retryTimeOut: TimeInterval = 2
	private var cancellables = Set<AnyCancellable>()
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	private var swapManager: SwapManager?

	// MARK: - Public Properties

	public let fromToken: SwapTokenViewModel
	public let toToken: SwapTokenViewModel
	public let swapRate: String
	public var gasFee: BigNumber!
	public let confirmButtonTitle = "Confirm"
	public let insufficientTitle = "Insufficient ETH Amount"

	public var selectedProtocolTitle: String!
	public var selectedProtocolImage: String!
	public var selectedProtocolName: String!

	@Published
	public var formattedFeeInETH: String?

	@Published
	public var formattedFeeInDollar: String?

	public let swapRateTitle = "Rate"
	public let feeTitle = "Fee"
	public let feeInfoActionSheetTitle = "Fee"
	public let feeInfoActionSheetDescription = "Sample Text"
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"

	// MARK: - Initializer

	init(
		fromToken: SwapTokenViewModel,
		toToken: SwapTokenViewModel,
		selectedProtocol: SwapProtocolModel,
		selectedProvider: SwapProviderViewModel?,
		swapRate: String
	) {
		self.fromToken = fromToken
		self.toToken = toToken
		self.selectedProtocol = selectedProtocol
		self.selectedProvider = selectedProvider
		self.swapRate = swapRate
		setSwapManager()
		setSelectedProtocol()
	}

	// MARK: - Public Methods

	public func fetchSwapInfo() {
		guard let swapManager else {
			DispatchQueue.main.asyncAfter(deadline: .now() + retryTimeOut) { [weak self] in
				self?.fetchSwapInfo()
			}
			return
		}
		swapManager.getSwapInfo().done { swapTrx, gasInfo in
			self.gasFee = gasInfo.fee
			self.formattedFeeInDollar = gasInfo.feeInDollar.priceFormat
			self.formattedFeeInETH = gasInfo.fee.sevenDigitFormat
		}.catch { error in
			Toast.default(
				title: "Failed to fetch Swap Info",
				subtitle: GlobalToastTitles.tryAgainToastTitle.message,
				style: .error
			).show()
		}
	}

	public func confirmSwap(completion: @escaping () -> Void) {
		guard let swapManager else {
			return
		}
		swapManager.confirmSwap { trx in
			print("SWAP TRX HASH: \(trx)")
			completion()
		}
	}

	public func checkEnoughBalance() -> Bool {
		if gasFee > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	// MARK: - Private Methods

	private func setSwapManager() {
		web3.getSwapProxyContract().done { swapProxyContract in
			self.swapManager = SwapManager(
				contract: swapProxyContract,
				selectedProvider: self.selectedProvider,
				srcToken: self.fromToken,
				destToken: self.toToken
			)
		}.catch { _ in
			self.setSwapManager()
		}
	}

	private func setSelectedProtocol() {
		if let selectedProvider {
			selectedProtocolTitle = "Provider"
			selectedProtocolImage = selectedProvider.provider.image
			selectedProtocolName = selectedProvider.provider.name
		} else {
			selectedProtocolTitle = "Protocol"
			selectedProtocolImage = selectedProtocol.image
			selectedProtocolName = selectedProtocol.name
		}
	}
}
