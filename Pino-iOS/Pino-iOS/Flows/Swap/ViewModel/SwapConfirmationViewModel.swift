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
        
        self.getSwapInfoFrom(provider: self.selectedProvService).done { response in
            print("RECEIVEDDDDDDDD")
        }
        
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
                    web3.getApproveCallData(
                        contractAdd: selectedProvider!.provider.contractAddress,
                        amount: try! BigUInt(UInt64.max),
                        spender: Web3Core.Constants.pinoProxyAddress).done { approveCallData in
                            seal.fulfill(approveCallData)
                        }.catch { error in
                            seal.reject(error)
                        }
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
        var priceRoute: PriceRoute? = nil
        if selectedProvider?.provider == .paraswap {
            let paraResponse = selectedProvider?.providerResponseInfo as! ParaSwapPriceResponseModel
            priceRoute = paraResponse.priceRoute
        }
        print(toToken.tokenAmount)
        let swapReq =
        SwapRequestModel(
            srcToken: fromToken.selectedToken.id,
            destToken: toToken.selectedToken.id,
            amount: toToken.tokenAmount!,
            sender: pinoWalletManager.currentAccount.eip55Address,
            slippage: (selectedProvider?.provider.slippage)!,
            networkID: 1,
            srcDecimal: fromToken.selectedToken.decimal.description,
            destDecimal: toToken.selectedToken.decimal.description,
            priceRoute: priceRoute
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
                print(swapResponseInfo)
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
    
}

{
  "srcToken": "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE", ✅
  "destToken": "0xdac17f958d2ee523a2206206994597c13d831ec7", ✅
  "srcAmount": "10000000000000000", ✅
  "destAmount": "29504841",
  "priceRoute": {
    "blockNumber": 13056637,
    "network": 1,
    "srcToken": "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
    "srcDecimals": 18,
    "srcAmount": "10000000000000000",
    "destToken": "0xdac17f958d2ee523a2206206994597c13d831ec7",
    "destDecimals": 6,
    "destAmount": "30708775",
    "bestRoute": [
      {
        "percent": 100,
        "swaps": [
          {
            "srcToken": "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
            "srcDecimals": 18,
            "destToken": "0xdac17f958d2ee523a2206206994597c13d831ec7",
            "destDecimals": 6,
            "swapExchanges": [
              {
                "exchange": "SakeSwap",
                "srcAmount": "10000000000000000",
                "destAmount": "30708775",
                "percent": 100,
                "data": {
                  "router": "0xF9234CB08edb93c0d4a4d4c70cC3FfD070e78e07",
                  "path": [
                    "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                    "0xdac17f958d2ee523a2206206994597c13d831ec7"
                  ],
                  "factory": "0x75e48C954594d64ef9613AeEF97Ad85370F13807",
                  "initCode": "0xb2b53dca60cae1d1f93f64d80703b888689f28b63c483459183f2f4271fa0308",
                  "feeFactor": 10000,
                  "pools": [
                    {
                      "address": "0xE2E5Aca8E483a4C057892EE1f03BEBc9BfA1F9C2",
                      "fee": 30,
                      "direction": true
                    }
                  ],
                  "gasUSD": "16.005884"
                }
              }
            ]
          }
        ]
      }
    ],
    "gasCostUSD": "17.836157",
    "gasCost": "111435",
    "side": "SELL",
    "tokenTransferProxy": "0x216b4b4ba9f3e719726886d34a177484278bfcae",
    "contractAddress": "0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57",
    "contractMethod": "swapOnUniswapFork",
    "partnerFee": 0,
    "srcUSD": "30.7085000000",
    "destUSD": "30.7087750000",
    "partner": "paraswap.io",
    "maxImpactReached": false,
    "hmac": "1ea308b9bcd027b4c89cebc260b550e812873191"
  }, ✅
  "userAddress": "0xbe0eb53f46cd790cd13851d5eff43d12404d33e8", ✅
  "partner": "paraswap.io",
  "srcDecimals": 18, ✅
  "destDecimals": 6 ✅
}
