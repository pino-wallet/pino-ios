//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import Combine
import PromiseKit
import Web3

class ApproveContractViewModel {
	// MARK: - Public Properties

	public var selectedProvider: SwapProvider!
	public var swapAmount: BigNumber!
	public var paraswapResponse: ParaSwapPriceResponseModel!

	public let pageTitle = "Asset approval"
	public let titleImageName = "approve_warning"
	public let learnMoreButtonTitle = "Learn more"
	public let approveText = "Approve permit 2 to access your"
	public let approveDescriptionText = "This will only happen one time."
	public let approveButtonTitle = "Approve"
	public let rightArrowImageName = "primary_right_arrow"

	#warning("this section is mock")
	public let learnMoreURL = "https://www.google.com"
	public let selectedToken = AssetViewModel(assetModel: BalanceAssetModel(
		id: "1",
		amount: "100000000000000000000",
		detail: Detail(
			id: "1",
			symbol: "USDC",
			name: "USDC",
			logo: "https://demo-cdn.pino.xyz/tokens/usdc.png",
			decimals: 18,
			change24H: "230",
			changePercentage: "23",
			price: "6089213"
		),
		previousDayNetworth: "100"
	), isSelected: true)

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

	public func approveProvider() -> String {
		web3.approveContract(
			address: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
			amount: 1_000_000,
			spender: "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C"
		)
		return "hi"
	}
}
