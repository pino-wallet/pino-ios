//
//  InvestManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 10/9/23.
//
import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class InvestManager: Web3ManagerProtocol {
	// MARK: - Private Properties

	private var investProtocol: InvestProtocolViewModel
	private var investAmount: String
	private let selectedToken: AssetViewModel
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private let web3Client = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()
	private var wethToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
	}

	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)!
	}

	// MARK: - Public Properties

	public var depositTrx: EthereumSignedTransaction?
	public var depositGasInfo: GasInfo?
	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Internal properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: Initializers

	init(
		contract: DynamicContract,
		selectedToken: AssetViewModel,
		investProtocol: InvestProtocolViewModel,
		investAmount: String
	) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.investProtocol = investProtocol
		self.investAmount = investAmount
	}

	// MARK: Public Methods

	public func getDepositInfo() -> TrxWithGasInfo? {
		switch investProtocol {
		case .maker:
			return investInDai()
		case .compound:
			return investInCompound()
		case .lido:
			return investInLido()
		case .aave:
			return nil
		case .balancer:
			return nil
		case .uniswap:
			return nil
		}
	}

	public func confirmDeposit(completion: @escaping (Result<String>) -> Void) {
		guard let depositTrx else { return }
		Web3Core.shared.callTransaction(trx: depositTrx).done { trxHash in
			#warning("Add transaction activity later")
			completion(.fulfilled(trxHash))
		}.catch { error in
			completion(.rejected(error))
		}
	}

	// MARK: - Private Methods

	private func investInDai() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<(String, String?)> in
				// Check allowance of protocol
				let spenderAddress = Web3Core.Constants.sDaiContractAddress
				return self.checkAllowanceOfProvider(
					approvingToken: self.selectedToken,
					approvingAmount: self.investAmount,
					spenderAddress: spenderAddress,
					ownerAddress: Web3Core.Constants.investContractAddress
				).map { (signiture, $0) }
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
				self.web3.getDaiToSDaiCallData(
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData, allowanceData) }
			}.then { protocolCallData, permitData, allowanceData in
				// MultiCall
				var callDatas = [permitData, protocolCallData]
				if let allowanceData { callDatas.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { depositResult in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				seal.fulfill(depositResult)
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func withdrawDai() {
		firstly {
			fetchHash()
		}.then { plainHash in
			self.signHash(plainHash: plainHash)
		}.then { signiture -> Promise<String> in
			// Permit Transform
			self.getProxyPermitTransferData(signiture: signiture)
		}.then { [self] permitData -> Promise<(String, String)> in
			self.web3.getSDaiToDaiCallData(
				amount: tokenUIntNumber,
				recipientAdd: walletManager.currentAccount.eip55Address
			).map { ($0, permitData) }
		}.then { protocolCallData, permitData in
			// MultiCall
			let callDatas = [permitData, protocolCallData]
			return self.callProxyMultiCall(data: callDatas, value: nil)
		}.done { trxHash in
			print(trxHash)
		}.catch { error in
			print(error.localizedDescription)
		}
	}

	private func investInLido() -> TrxWithGasInfo {
		if selectedToken.isEth {
			return lidoETHDeposit()
		} else if selectedToken.isWEth {
			return lidoWETHDeposit()
		} else {
			fatalError("Wrong token for lido investment")
		}
	}

	private func lidoETHDeposit() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			let proxyFee = 0.bigNumber.bigUInt
			firstly {
				self.web3.getETHToSTETHCallData(
					recipientAdd: walletManager.currentAccount.eip55Address,
					proxyFee: proxyFee
				)
			}.then { protocolCallData in
				// MultiCall
				let callDatas = [protocolCallData]
				let ethDepositAmount = self.tokenUIntNumber + proxyFee
				return self.callProxyMultiCall(data: callDatas, value: ethDepositAmount)
			}.done { depositResult in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				seal.fulfill(depositResult)
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func lidoWETHDeposit() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getWETHToSTETHCallData(
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData) }
			}.then { protocolCallData, permitData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { depositResult in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				seal.fulfill(depositResult)
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func lodoWithdraw() {}

	private func investInCompound() -> TrxWithGasInfo {
		let compoundManager = CompoundDepositManager(
			contract: contract,
			selectedToken: selectedToken,
			investAmount: investAmount
		)
		return compoundManager.getDepositInfo()
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: selectedToken.id,
				amount: tokenUIntNumber.description,
				spender: Web3Core.Constants.investContractAddress,
				nonce: nonce.description,
				deadline: deadline.description
			)

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

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}

	// MARK: Internal Methods

	internal func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract,
			amount: tokenUIntNumber,
			tokenAdd: selectedToken.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}
}
