//
//  SwapManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/11/23.
//

import Foundation
import Combine
import PromiseKit
import Web3_Utility
import BigInt

class SwapManager {
    
    // MARK: - Private Properties
    
    private let selectedProvider: SwapProviderViewModel
    private var web3 = Web3Core.shared
    private var srcToken: SwapTokenViewModel
    private var destToken: SwapTokenViewModel
    
    private var pinoWalletManager = PinoWalletManager()
    private let paraSwapAPIClient = ParaSwapAPIClient()
    private let oneInchAPIClient = OneInchAPIClient()
    private let zeroXAPIClient = ZeroXAPIClient()
    private let web3Client = Web3APIClient()
    private var cancellables = Set<AnyCancellable>()

    init(selectedProvider: SwapProviderViewModel, srcToken: SwapTokenViewModel, destToken: SwapTokenViewModel) {
        self.selectedProvider = selectedProvider
        self.srcToken = srcToken
        self.destToken = destToken
    }
    
    // MARK: - Public Methods

    public func swapToken() {
        swapERCtoERC(srcToken: srcToken, destToken: destToken)
    }
    
    // MARK: - Private Methods
    
    private func swapERCtoERC(srcToken: SwapTokenViewModel, destToken: SwapTokenViewModel) {
        firstly {
            checkAllowanceOfProvider()
        }.compactMap({ allowanceData in
            allowanceData
        }).then { allowanceData in
            self.signHash().map { ($0, allowanceData) }
        }.then { signiture, allowanceData in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData in
            // Fetch Call Data
            self.getSwapInfoFrom(provider: selectedProvService).map { ($0, permitData, allowanceData) }
        }.then { swapData, permitData, allowanceData in
            // MultiCall
            self.callProxyMultiCall(data: [allowanceData, swapData, permitData ])
        }.done { trxHash in
            
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func signHash() -> Promise<String> {
        Promise<String> { seal in
            firstly {
                fetchHash()
            }.done { [self] hash in
                let signiture = try Sec256k1Encryptor.sign(msg: hash.hexToBytes(), seckey: pinoWalletManager.currentAccountPrivateKey.string.hexToBytes())
                seal.fulfill(signiture.toHexString())
            }.catch { error in
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
    private func fetchHash() -> Promise<String> {
        Promise<String> { seal in
            
            let hashREq = EIP712HashRequestModel(tokenAdd: srcToken.selectedToken.id, amount:
            srcToken.tokenAmountBigNum.description, spender: Web3Core.Constants.pinoProxyAddress)
            
            web3Client.getHashTypedData(eip712HashReqInfo: hashREq).sink { completed in
                switch completed {
                    case .finished:
                        print("Info received successfully")
                    case let .failure(error):
                        print(error)
                }
            } receiveValue: { hashResponse in
                seal.fulfill(hashResponse.hash)
            }.store(in: &cancellables)
        }
    }
    
    private func checkAllowanceOfProvider() -> Promise<String?> {
        Promise<String?> { seal in
            firstly {
                try web3.getAllowanceOf(
                    contractAddress: destToken.selectedToken.id,
                    spenderAddress: selectedProvider.provider.contractAddress,
                    ownerAddress: Web3Core.Constants.pinoProxyAddress
                )
            }.done { [self] allowanceAmount in
                let destTokenDecimal = destToken.selectedToken.decimal
                let destTokenAmount = Utilities.parseToBigUInt(destToken.tokenAmount!, decimals: destTokenDecimal)!
                if allowanceAmount == 0 || allowanceAmount < destTokenAmount {
                    web3.getApproveProxyCallData(
                        tokenAdd: destToken.selectedToken.id,
                        spender: selectedProvider.provider.contractAddress
                    ).done { approveCallData in
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
    
    private func getProxyPermitTransferData(signiture: String) -> Promise<String> {
        web3.getPermitTransferCallData(amount: srcToken.tokenAmountBigNum.bigUInt, signiture: signiture)
    }
    
    private func getSwapInfoFrom<SwapProvider: SwapProvidersAPIServices>(provider: SwapProvider) -> Promise<String> {
        var priceRoute: PriceRouteClass?
        if selectedProvider.provider == .paraswap {
            let paraResponse = selectedProvider.providerResponseInfo as! ParaSwapPriceResponseModel
            priceRoute = paraResponse.priceRoute
        }
        if selectedProvider.provider == .zeroX {
            let zeroxResponse = selectedProvider.providerResponseInfo as! ZeroXPriceResponseModel
            return zeroxResponse.data.promise
        }

        let swapReq =
            SwapRequestModel(
                srcToken: srcToken.selectedToken.id,
                destToken: destToken.selectedToken.id,
                amount: srcToken.tokenAmountBigNum.description,
                destAmount: (selectedProvider.providerResponseInfo.destAmount),
                receiver: pinoWalletManager.currentAccount.eip55Address,
                userAddress: pinoWalletManager.currentAccount.eip55Address,
                slippage: (selectedProvider.provider.slippage),
                networkID: 1,
                srcDecimal: srcToken.selectedToken.decimal.description,
                destDecimal: destToken.selectedToken.decimal.description,
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
                seal.fulfill(swapResponseInfo!.data)
            }.store(in: &cancellables)
        }
    }

    private func callProxyMultiCall(data: [String]) -> Promise<String> {
        Promise<String> { seal in
            seal.fulfill("hi")
        }
    }
    
    private var selectedProvService: any SwapProvidersAPIServices {
        switch selectedProvider.provider {
        case .oneInch:
            return oneInchAPIClient
        case .paraswap:
            return paraSwapAPIClient
        case .zeroX:
            return zeroXAPIClient
        }
    }
    
    
    
}
