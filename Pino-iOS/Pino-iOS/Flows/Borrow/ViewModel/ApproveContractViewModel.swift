//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import PromiseKit
import Web3
import Combine

public enum SwapProviders {
	case paraSwap
	case zeroX
	case oneInch
}

class ApproveContractViewModel {
	// MARK: - Public Properties
    public var selectedProvider: SwapProvider!
    public var swapAmount: BigNumber!
    public var paraswapResponse: ParaSwapPriceResponseModel!
	// MARK: - Private Properties

	private var web3 = Web3Core.shared
	private var pinoWalletManager = PinoWalletManager()
	private let paraSwapAPIClient = ParaSwapAPIClient()
	private let oneInchAPIClient = OneInchAPIClient()
	private let zeroXAPIClient = ZeroXAPIClient()
    private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

    public func confirmSwap() {
        firstly {
            checkProtocolAllowanceOf(contractAddress: selectedProvider.contractAddress)
        }.compactMap({ allowanceData in
            return allowanceData
        }).then { allowanceData in
            self.getSwapInfoFrom(provider: self.selectedProvService).map{ ($0, allowanceData) }
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
    
    private var selectedProvService: any SwapProvidersAPIServices {
        switch selectedProvider {
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
                    spenderAddress: selectedProvider.contractAddress,
                    ownerAddress: Web3Core.Constants.pinoProxyAddress
                )
            }.done { [self] allowanceAmount in
                if allowanceAmount == 0 || allowanceAmount < swapAmount.number {
                    // NOT ALLOWED
                    let approveData = approveProvider()
                    seal.fulfill(approveData)
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
            slippage: selectedProvider.slippage,
            networkID: 1,
            srcDecimal: "6",
            destDecimal: "18",
            priceRoute: nil)
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
    
    private func approveProvider() -> String {
        "hi"
    }

}
