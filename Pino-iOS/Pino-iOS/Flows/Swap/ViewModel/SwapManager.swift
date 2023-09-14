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
        swapERCtoERC()
    }
    
    // MARK: - Private Methods
    
    private func swapERCtoERC() {
        firstly {
            checkAllowanceOfProvider().compactMap { ($0) }
        }.then { allowanceData in
            self.signHash().map { ($0, allowanceData) }
        }.then { signiture, allowanceData in
            // Permit Transform
//            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
            "data".promise.map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData in
            // Fetch Call Data
            getSwapInfoFrom(provider: selectedProvService).map { ($0, permitData, allowanceData) }
        }.then { providerSwapData, permitData, allowanceData in
            self.getProvidersCallData(providerData: providerSwapData).map { ($0, permitData, allowanceData)  }
        }.then { providersCallData, permitData, allowanceData -> Promise<(String?, String, String, String)> in
            self.sweepTokenCallData().map { ($0, providersCallData, permitData, allowanceData) }
        }.then { sweepData, providersCallData, permitData, allowanceData in
            // MultiCall
            var callDatas = [allowanceData, permitData, providersCallData]
            if let sweepData { callDatas.append(sweepData) }
            return self.callProxyMultiCall(data: callDatas)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // TODO: Set providers dest token in 0x as WETH since dest is ETH
    private func swapERCtoETH() {
        firstly {
            checkAllowanceOfProvider().compactMap { ($0) }
        }.then { allowanceData in
            self.signHash().map { ($0, allowanceData) }
        }.then { signiture, allowanceData in
            // Permit Transform
//            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
            "data".promise.map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData in
            // Fetch Call Data
            getSwapInfoFrom(provider: selectedProvService).map { ($0, permitData, allowanceData) }
        }.then { providerSwapData, permitData, allowanceData in
            self.getProvidersCallData(providerData: providerSwapData).map { ($0, permitData, allowanceData)  }
        }.then { providersCallData, permitData, allowanceData -> Promise<(String?, String, String, String)> in
            self.unwrapTokenCallData().map { ($0, providersCallData, permitData, allowanceData) }
        }.then { unwrapData, providersCallData, permitData, allowanceData in
            // MultiCall
            var callDatas = [allowanceData, permitData, providersCallData]
            if let unwrapData { callDatas.append(unwrapData) }
            return self.callProxyMultiCall(data: callDatas)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    // TODO: Set providers src token as WETH since src is ETH
    private func swapETHtoERC() {
        firstly {
            self.wrapTokenCallData()
        }.then { wrapTokenData in
            // Fetch Call Data
            self.getSwapInfoFrom(provider: self.selectedProvService).map { ($0, wrapTokenData) }
        }.then { providerSwapData, wrapTokenData in
            self.getProvidersCallData(providerData: providerSwapData).map { ($0, wrapTokenData)  }
        }.then { providersCallData, wrapTokenData -> Promise<(String?, String, String)> in
            self.sweepTokenCallData().map { ($0, providersCallData, wrapTokenData) }
        }.then { sweepData, providersCallData, wrapTokenData in
            // MultiCall
            var callDatas = [providersCallData, wrapTokenData]
            if let sweepData { callDatas.append(sweepData) }
            return self.callProxyMultiCall(data: callDatas)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func swapETHtoWETH() {
        firstly {
            self.wrapTokenCallData()
        }.then { wrapTokenData -> Promise<(String?, String)> in
            // Fetch Call Data
            self.sweepTokenCallData().map { ($0, wrapTokenData) }
        }.then { sweepData, wrapTokenData in
            // MultiCall
            var callDatas = [wrapTokenData]
            if let sweepData { callDatas.append(sweepData) }
            return self.callProxyMultiCall(data: callDatas)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func swapWETHtoETH() {
        firstly {
            self.signHash().map { ($0) }
        }.then { signiture in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0) }
        }.then { permitData in
            self.unwrapTokenCallData().map { ($0, permitData) }
        }.then { unwrapData, permitData  in
            // MultiCall
            return self.callProxyMultiCall(data: [unwrapData, permitData])
        }.done { trxHash in
            print(trxHash)
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
        web3.getPermitTransferCallData(amount: srcToken.tokenAmountBigNum.bigUInt, tokenAdd: srcToken.selectedToken.id, signiture: signiture)
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
    
    private func sweepTokenCallData() -> Promise<String?> {
        Promise<String?> { seal in
            if selectedProvider.provider == .zeroX {
                seal.fulfill(nil)
            } else {
                web3.getSweepTokenCallData(tokenAdd: srcToken.selectedToken.id, recipientAdd: pinoWalletManager.currentAccount.eip55Address).done { sweepData in
                    seal.fulfill(sweepData)
                }.catch { error in
                    print(error)
                }
            }
        }
    }
    
    private func wrapTokenCallData() -> Promise<String> {
        web3.getWrapETHCallData(amount: srcToken.tokenAmountBigNum.bigUInt, proxyFee: 0)
    }
    
    private func unwrapTokenCallData() -> Promise<String> {
        web3.getUnwrapETHCallData(amount: destToken.tokenAmountBigNum.bigUInt, recipient: pinoWalletManager.currentAccount.eip55Address)
    }
    
    private func getProvidersCallData(providerData: String) -> Promise<String> {
        switch selectedProvider.provider {
        case .zeroX:
            return web3.getZeroXSwapCallData(data: providerData)
        case .oneInch:
            return web3.getOneInchSwapCallData(data: providerData)
        case .paraswap:
            return web3.getParaswapSwapCallData(data: providerData)
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
