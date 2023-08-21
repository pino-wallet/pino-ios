//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import PromiseKit
import Web3

public enum SwapProviders {
    case paraSwap
    case zeroX
    case oneInch
}

struct ApproveContractViewModel {
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

	// MARK: - Public Methods

    public func confirmSwap() {
        firstly {
            checkProtocolAllowanceOf(contractAddress: selectedProvider.contractAddress)
        }.compactMap({ allowanceData in
            return allowanceData
        }).then { allowanceData in
            getSwapInfoFrom(provider: selectedProvider.providerService).map{ ($0, allowanceData) }
        }.then { swapData, allowanceData in
            getProxyPermitTransferData().map { ($0, swapData, allowanceData) }
        }.then { transferData, swapData, approveData in
            callProxyMultiCall(data: [approveData, swapData, transferData])
        }.done { hash in
            print(hash)
        }.catch { error in
            print(error)
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
            }.done { allowanceAmount in
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
    
    private func getSwapInfoFrom(provider: any SwapProvidersAPIServices) -> Promise<String> {
        Promise<String> { seal in
            seal.fulfill("hi")
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

    
	public func allowPinoProxyContract() throws {
		let trxAmount = 0
		firstly {
			try web3.getAllowanceOf(
				contractAddress: "Uni Contract Address",
				spenderAddress: "Para Swap",
				ownerAddress: Web3Core.Constants.pinoProxyAddress
			)
		}.done { allowanceAmount in
			if allowanceAmount == 0 || allowanceAmount < trxAmount {
				// NOT ALLOWED -> SHOW APPROVE PAGE

			} else {
				// ALLOWED -> SHOW CONFIRM PAGE
			}
		}.catch { error in
			print(error)
		}
	}
}
