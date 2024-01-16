//
//  SwapManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/11/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class SwapManager: Web3ManagerProtocol {
	// MARK: - Typealias

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()
	internal var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	// MARK: - Private Properties

	private var pendingSwapGasInfo: GasInfo?
	private var swapPriceManager = SwapPriceManager()
	private var selectedProvider: SwapProviderViewModel?
	private var srcToken: AssetViewModel
	private var destToken: AssetViewModel
	private var wethToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
	}

	private var enteredSwapAmount: String
	private var destinationAmount: String
	private var swapAmountBigNum: BigNumber {
		let tokenUIntNumber = Utilities.parseToBigUInt(enteredSwapAmount, decimals: srcToken.decimal)
		return .init(unSignedNumber: tokenUIntNumber!, decimal: srcToken.decimal)
	}

	private let coreDataManager = CoreDataManager()
	private let paraSwapAPIClient = ParaSwapAPIClient()
	private let oneInchAPIClient = OneInchAPIClient()
	private let zeroXAPIClient = ZeroXAPIClient()
	private let web3Client = Web3APIClient()

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber

	init(
		selectedProvider: SwapProviderViewModel?,
		srcToken: AssetViewModel,
		destToken: AssetViewModel,
		swapAmount: String,
		destinationAmount: String
	) {
		self.selectedProvider = selectedProvider
		self.srcToken = srcToken
		self.destToken = destToken
		self.contract = try! web3.getSwapProxyContract()
		self.enteredSwapAmount = swapAmount
		self.destinationAmount = destinationAmount
	}

	// MARK: - Public Methods

	public func getSwapInfo() -> TrxWithGasInfo {
		if (srcToken.isERC20 || srcToken.isWEth) &&
			(destToken.isERC20 || destToken.isWEth) {
			return swapERCtoERC()
		} else if srcToken.isERC20 && destToken.isEth {
			return swapERCtoETH()
		} else if srcToken.isEth && destToken.isERC20 {
			return swapETHtoERC()
		} else if srcToken.isEth && destToken.isWEth {
			return swapETHtoWETH()
		} else if srcToken.isWEth && destToken.isEth {
			return swapWETHtoETH()
		} else {
			fatalError()
		}
	}

	public func confirmSwap(swapTrx trx: EthereumSignedTransaction, completion: @escaping (Result<String>) -> Void) {
		Web3Core.shared.callTransaction(trx: trx).done { trxHash in
			self.addPendingTransferActivity(trxHash: trxHash)
			completion(.fulfilled(trxHash))
		}.catch { error in
			completion(.rejected(error))
		}
	}

	// MARK: - Internal Methods

	internal func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract, amount: swapAmountBigNum.bigUInt,
			tokenAdd: srcToken.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	// MARK: - Private Methods

	private func swapERCtoERC() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { [self] signiture -> Promise<(String, String?)> in
				guard let selectedProvider else { fatalError("provider errror") }
				return checkAllowanceOfProvider(
					approvingToken: srcToken,
					approvingAmount: swapAmountBigNum.bigIntFormat,
					spenderAddress: selectedProvider.provider.contractAddress
				).map { (signiture, $0) }
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
				// Fetch Call Data
				getSwapInfoFrom().map { ($0, permitData, allowanceData) }
			}.then { providerSwapData, permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getProvidersCallData(providerData: providerSwapData).map { ($0, permitData, allowanceData) }
			}.then { providersCallData, permitData, allowanceData -> Promise<(String?, String, String, String?)> in
				self.sweepTokenCallData().map { ($0, providersCallData, permitData, allowanceData) }
			}.then { sweepData, providersCallData, permitData, allowanceData in
				// MultiCall
				var callDatas = [permitData, providersCallData]
				if let allowanceData { callDatas.insert(allowanceData, at: 0) }
				if let sweepData { callDatas.append(sweepData) }
				return attempt(maximumRetryCount: 3) { [self] in
					callProxyMultiCall(data: callDatas, value: nil)
				}
			}.done { swapResult in
				self.pendingSwapGasInfo = swapResult.1
				seal.fulfill(swapResult)
			}.catch { error in
				print(error.localizedDescription)
				seal.reject(error)
			}
		}
	}

	private func swapERCtoETH() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in

			guard let selectedProvider else { fatalError("provider errror") }
			let fetchHashPromise = fetchHash()
			let allowancePromise = checkAllowanceOfProvider(
				approvingToken: srcToken,
				approvingAmount: swapAmountBigNum.bigIntFormat,
				spenderAddress: selectedProvider.provider.contractAddress
			)
			let swapProvidersDataPromise = getSwapInfoFrom()
			let unwrapPromise = self.unwrapTokenCallData()

			firstly {
				when(fulfilled: fetchHashPromise, allowancePromise, swapProvidersDataPromise, unwrapPromise)
			}
			.then { plainHash, allowanceData, swapProviderData, unwrapCallData -> Promise<(
				(String, String),
				String?,
				String?
			)> in
				let signHashPromise = self.signHash(plainHash: plainHash)
				let permitTransferPromise = signHashPromise.then { signiture in
					self.getProxyPermitTransferData(signiture: signiture)
				}
				let providerCallData = self.getProvidersCallData(providerData: swapProviderData)
				return when(fulfilled: permitTransferPromise, providerCallData)
					.map { ($0, allowanceData, unwrapCallData) }
			}.then { ptfAndProviderCallData, allowanceData, unwrapCallData in
				var callDatas = [ptfAndProviderCallData.0, ptfAndProviderCallData.1]
				if let allowanceData { callDatas.insert(allowanceData, at: 0) }
				if let unwrapCallData { callDatas.append(unwrapCallData) }
				return attempt(maximumRetryCount: 3) { [self] in
					callProxyMultiCall(data: callDatas, value: nil)
				}
			}.done { swapResult in
				self.pendingSwapGasInfo = swapResult.1
				seal.fulfill(swapResult)
			}.catch { error in
				print(error.localizedDescription)
				seal.reject(error)
			}
		}
	}

	private func swapETHtoERC() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				self.wrapTokenCallData()
			}.then { [self] wrapTokenData -> Promise<(String?, String)> in
				guard let selectedProvider else { fatalError("provider errror") }
				return checkAllowanceOfProvider(
					approvingToken: wethToken,
					approvingAmount: swapAmountBigNum.bigIntFormat,
					spenderAddress: selectedProvider.provider.contractAddress
				).map { ($0, wrapTokenData) }
			}.then { [self] allowanceData, wrapTokenData -> Promise<(String, String?, String)> in
				// Fetch Call Data
				getSwapInfoFrom().map { ($0, allowanceData, wrapTokenData) }
			}.then { providerSwapData, allowanceData, wrapTokenData -> Promise<(String, String?, String)> in
				self.getProvidersCallData(providerData: providerSwapData).map { ($0, allowanceData, wrapTokenData) }
			}.then { providersCallData, allowanceData, wrapTokenData -> Promise<(String?, String, String?, String)> in
				self.sweepTokenCallData().map { ($0, providersCallData, allowanceData, wrapTokenData) }
			}.then { sweepData, providersCallData, allowanceData, wrapTokenData in
				// MultiCall
				var callDatas = [wrapTokenData, providersCallData]
				if let sweepData { callDatas.append(sweepData) }
				if let allowanceData { callDatas.insert(allowanceData, at: 0) }
				return attempt(maximumRetryCount: 3) { [self] in
					callProxyMultiCall(data: callDatas, value: swapAmountBigNum.bigUInt)
				}
			}.done { swapResult in
				self.pendingSwapGasInfo = swapResult.1
				seal.fulfill(swapResult)
			}.catch { error in
				print(error.localizedDescription)
				seal.reject(error)
			}
		}
	}

	private func swapETHtoWETH() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				self.wrapTokenCallData()
			}.then { wrapTokenData -> Promise<(String?, String)> in
				// Fetch Call Data
				// TODO: EVEN IF ZEROX -> Sweep should happen
				self.sweepTokenCallData().map { ($0, wrapTokenData) }
			}.then { sweepData, wrapTokenData in
				// MultiCall
				let callDatas = [wrapTokenData, sweepData!]
				return attempt(maximumRetryCount: 3) { [self] in
					callProxyMultiCall(data: callDatas, value: swapAmountBigNum.bigUInt)
				}
			}.done { swapResult in
				self.pendingSwapGasInfo = swapResult.1
				seal.fulfill(swapResult)
			}.catch { error in
				print(error.localizedDescription)
				seal.reject(error)
			}
		}
	}

	private func swapWETHtoETH() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { $0 }
			}.then { permitData -> Promise<(String?, String)> in
				self.unwrapTokenCallData().map { ($0, permitData) }
			}.then { unwrapData, permitData in
				// MultiCall
				self.callProxyMultiCall(data: [permitData, unwrapData!], value: nil)
			}.done { swapResult in
				self.pendingSwapGasInfo = swapResult.1
				seal.fulfill(swapResult)
			}.catch { error in
				print(error.localizedDescription)
				seal.reject(error)
			}
		}
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in
			let hashREq = EIP712HashRequestModel(
				tokenAdd: srcToken.id,
				amount: swapAmountBigNum.bigIntFormat,
				spender: Web3Core.Constants.pinoSwapProxyAddress,
				nonce: nonce.description,
				deadline: deadline.description
			)

			web3Client.getHashTypedData(eip712HashReqInfo: hashREq.eip712HashReqBody).sink { completed in
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

	private func getSwapInfoFrom() -> Promise<String> {
		guard let selectedProvider else { fatalError("provider errror") }

		var priceRoute: Data?
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
				srcToken: srcToken.id,
				destToken: destToken.id,
				amount: swapAmountBigNum.bigIntFormat,
				destAmount: selectedProvider.providerResponseInfo.destAmount,
				receiver: walletManager.currentAccount.eip55Address,
				userAddress: Web3Core.Constants.pinoSwapProxyAddress,
				slippage: selectedProvider.provider.slippage,
				networkID: 1,
				srcDecimal: srcToken.decimal.description,
				destDecimal: destToken.decimal.description,
				priceRoute: priceRoute,
				provider: selectedProvider.provider
			)
		return Promise<String> { seal in
			callSwapFunction(swapReq: swapReq) { swapResponse in
				seal.fulfill(swapResponse)
			}
		}
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}

	private func sweepTokenCallData() -> Promise<CallData?> {
		if let selectedProvider {
			if selectedProvider.provider == .zeroX {
				return sweepToken(tokenAddress: destToken.id)
			} else {
				return Promise<String?>() { seal in seal.fulfill(nil) }
			}
		} else {
			if destToken.isWEth {
				return sweepToken(tokenAddress: destToken.id)
			} else {
				return Promise<String?>() { seal in seal.fulfill(nil) }
			}
		}
	}

	private func unwrapTokenCallData() -> Promise<String?> {
		if let selectedProvider {
			if selectedProvider.provider == .zeroX {
				return unwrapToken()
			} else {
				return Promise<String?>() { seal in seal.fulfill(nil) }
			}

		} else {
			if destToken.isEth {
				return unwrapToken()
			} else {
				return Promise<String?>() { seal in seal.fulfill(nil) }
			}
		}
	}

	private func getProvidersCallData(providerData: String) -> Promise<String> {
		guard let selectedProvider else { fatalError("provider errror") }

		switch selectedProvider.provider {
		case .zeroX:
			return web3.getZeroXSwapCallData(data: providerData)
		case .oneInch:
			return web3.getOneInchSwapCallData(data: providerData)
		case .paraswap:
			return web3.getParaswapSwapCallData(data: providerData)
		}
	}

	private func callSwapFunction(swapReq: SwapRequestModel, completion: @escaping (String) -> Void) {
		guard let selectedProvider else { return }
		switch selectedProvider.provider {
		case .oneInch:
			oneInchAPIClient.swap(swapInfo: swapReq).sink { completed in
				switch completed {
				case .finished:
					print("Swap info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { swapResponseInfo in
				completion(swapResponseInfo!.data)
			}.store(in: &cancellables)
		case .paraswap:
			paraSwapAPIClient.swap(swapInfo: swapReq).sink { completed in
				switch completed {
				case .finished:
					print("Swap info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { swapResponseInfo in
				completion(swapResponseInfo!.data)
			}.store(in: &cancellables)
		case .zeroX:
			zeroXAPIClient.swap(swapInfo: swapReq).sink { completed in
				switch completed {
				case .finished:
					print("Swap info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { swapResponseInfo in
				completion(swapResponseInfo!.data)
			}.store(in: &cancellables)
		}
	}

	public func addPendingTransferActivity(trxHash: String) {
		guard let selectedProvider else { return }
		guard let pendingSwapGasInfo = pendingSwapGasInfo else { return }
		let userAddress = walletManager.currentAccount.eip55Address
		coreDataManager.addNewSwapActivity(
			activityModel: .init(
				txHash: trxHash,
				type: ActivityType.swap.rawValue,
				detail: .init(
					fromToken: .init(
						amount: swapAmountBigNum.bigIntFormat,
						tokenID: srcToken.id
					),
					toToken: .init(
						amount: Utilities
							.parseToBigUInt(destinationAmount, decimals: destToken.decimal)!
							.description,
						tokenID: destToken.id
					),
					activityProtocol: selectedProvider.provider.name
				),
				fromAddress: userAddress,
				toAddress: selectedProvider.provider.contractAddress,
				blockTime: ActivityHelper().getServerFormattedStringDate(date: .now),
				gasUsed: pendingSwapGasInfo.increasedGasLimit!.bigIntFormat,
				gasPrice: pendingSwapGasInfo.baseFeeWithPriorityFee.bigIntFormat
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}
}
