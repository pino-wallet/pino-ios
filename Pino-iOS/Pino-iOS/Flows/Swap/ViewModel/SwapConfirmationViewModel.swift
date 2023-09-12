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
	private var cancellables = Set<AnyCancellable>()
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

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
		setSelectedProtocol()
		setupBindings()
	}

	// MARK: - Public Methods

	public func checkEnoughBalance() -> Bool {
		if gasFee > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	// MARK: - Private Methods

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

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee.sink { fee, feeInDollar in
			self.gasFee = fee
			self.formattedFeeInETH = fee.sevenDigitFormat.ethFormatting
			self.formattedFeeInDollar = feeInDollar.priceFormat
		}.store(in: &cancellables)
	}
}

extension SwapConfirmationViewModel {
	public func confirmSwap() {
		//        

		//        firstly {
		//            // First we check if Pino-Proxy has access to Selected Swap Provider
		//            // 1: True -> We Skip to next part
		//            // 2: False -> We get CallData and pass to next part
		//            checkProtocolAllowanceOf(contractAddress: selectedProvider!.provider.contractAddress)
		//        }.compactMap { allowanceData in
		//            allowanceData
		//        }.then { allowanceData in
		//            // Get Swap Call Data from Provider
		//            self.getSwapInfoFrom(provider: self.selectedProvService).map { ($0, allowanceData) }
		//        }.then { swapData, allowanceData in
		//            // TODO: Needs to be handled after meeting with Ali
		//            self.getProxyPermitTransferData().map { ($0, swapData, allowanceData) }
		//        }.then { transferData, swapData, approveData in
		//            self.callProxyMultiCall(data: [approveData, swapData, transferData])
		//        }.done { hash in
		//            print(hash)
		//        }.catch { error in
		//            print(error)
		//        }
	}

	// MARK: - Private Methods

	

	

	
	
}
