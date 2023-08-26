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
    
    private var web3 = Web3Core.shared
    private var pinoWalletManager = PinoWalletManager()
    private let paraSwapAPIClient = ParaSwapAPIClient()
    private let oneInchAPIClient = OneInchAPIClient()
    private let zeroXAPIClient = ZeroXAPIClient()

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
        firstly {
            checkProtocolAllowanceOf(contractAddress: selectedProvider!.provider.contractAddress)
        }.compactMap { allowanceData in
            allowanceData
        }.then { allowanceData in
            self.getSwapInfoFrom(provider: self.selectedProvService).map { ($0, allowanceData) }
        }.then { swapData, allowanceData in
            self.getProxyPermitTransferData().map { ($0, swapData, allowanceData) }
        }.then { transferData, swapData, approveData in
            self.callProxyMultiCall(data: [approveData, swapData, transferData])
        }.done { hash in
            print(hash)
        }.catch { error in
            print(error)
        }
    }
    
    // MARK: - Private Methods
    
    private var selectedProvService: any SwapProvidersAPIServices {
        switch selectedProvider?.provider {
            case .oneInch:
                return oneInchAPIClient
            case .paraswap:
                return paraSwapAPIClient
            case .zeroX:
                return zeroXAPIClient
            case .none:
                fatalError()
        }
    }
    
    private func checkProtocolAllowanceOf(contractAddress: String) -> Promise<String?> {
        Promise<String?> { seal in
            firstly {
                try web3.getAllowanceOf(
                    contractAddress: contractAddress,
                    spenderAddress: selectedProvider!.provider.contractAddress,
                    ownerAddress: Web3Core.Constants.pinoProxyAddress
                )
            }.done { [self] allowanceAmount in
                let destTokenDecimal = toToken.selectedToken.decimal
                let destTokenAmount = Utilities.parseToBigUInt(toToken.tokenAmount!, decimals: destTokenDecimal)!
                if allowanceAmount == 0 || allowanceAmount < destTokenAmount {
                    // NOT ALLOWED
                    let approveData = approveProvider()
                    seal.fulfill("approveData")
                } else {
                    // ALLOWED
                    seal.fulfill(nil)
                }
            }.catch { error in
                print(error)
            }
        }
    }
    
    private func getSwapInfoFrom<SwapProvider: SwapProvidersAPIServices>(provider: SwapProvider) -> Promise<String> {
        let swapReq =
        SwapRequestModel(
            srcToken: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            destToken: "0x514910771AF9Ca656af840dff83E8264EcF986CA",
            amount: "10000000",
            receiver: "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C",
            sender: "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C",
            slippage: (selectedProvider?.provider.slippage)!,
            networkID: 1,
            srcDecimal: "6",
            destDecimal: "18",
            priceRoute: nil
        )
        return Promise<String> { seal in
            provider.swap(swapInfo: swapReq).sink { completed in
                switch completed {
                    case .finished:
                        print("Swap info received successfully")
                    case let .failure(error):
                        print(error)
                }
            } receiveValue: { swapResponseInfo in
                
            }.store(in: &cancellables)
        }
    }
    
    private func getProxyPermitTransferData() -> Promise<String> {
        Promise<String> { seal in
            seal.fulfill("hi")
        }
    }
    
    private func callProxyMultiCall(data: [String]) -> Promise<String> {
        Promise<String> { seal in
            seal.fulfill("hi")
        }
    }
    
    public func approveProvider() -> Promise<String> {
        web3.approveContract(
            address: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            amount: 1_000_000,
            spender: "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C"
        )
    }
    
}
