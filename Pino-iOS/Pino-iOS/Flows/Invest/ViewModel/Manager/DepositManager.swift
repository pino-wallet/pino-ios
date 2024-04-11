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

class DepositManager: InvestW3ManagerProtocol {
	// MARK: - Private Properties

	private var investAmount: String
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)!
	}

	// MARK: - Public Properties

	public var compoundManager: CompoundDepositManager
	public var aaveManager: AaveDepositManager
	public var depositTrx: EthereumSignedTransaction?
	public var depositGasInfo: GasInfo?
	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Internal properties

	internal var selectedProtocol: InvestProtocolViewModel
	internal let selectedToken: AssetViewModel
	internal var tokenPositionID: String!
	internal var cancellables = Set<AnyCancellable>()
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
		self.selectedProtocol = investProtocol
		self.investAmount = investAmount
		self.compoundManager = CompoundDepositManager(
			contract: contract,
			selectedToken: selectedToken,
			investAmount: investAmount,
			type: .invest
		)
		self.aaveManager = AaveDepositManager(
			contract: contract,
			selectedToken: selectedToken,
			depositAmount: investAmount
		)
	}

	// MARK: Public Methods

	public func getDepositInfo() -> Promise<[GasInfo]> {
		switch selectedProtocol {
		case .maker:
			return getMakerDepositInfo()
		case .compound:
			return compoundManager.getDepositInfo()
		case .lido:
			return getLidoDepositInfo()
		case .aave:
			return aaveManager.getERC20DepositInfo()
		}
	}

	public func getIncreaseDepositInfo() -> Promise<[GasInfo]> {
		switch selectedProtocol {
		case .maker:
			return getMakerDepositInfo()
		case .compound:
			return compoundManager.getIncreaseDepositInfo()
		case .lido:
			return getLidoDepositInfo()
		case .aave:
			return aaveManager.getIncreaseDepositInfo()
		}
	}

	// MARK: - Private Methods

	private func getMakerDepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { [self] signiture -> Promise<(String, String?)> in
				// Check allowance of protocol
				checkAllowanceOfProvider(
					approvingToken: selectedToken,
					approvingAmount: investAmount,
					spenderAddress: tokenPositionID,
					ownerAddress: Web3Core.Constants.investContractAddress
				).map { (signiture, $0) }
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
				web3.getDaiToSDaiCallData(
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
				seal.fulfill([depositResult.1])
			}.catch { error in
				print("W3 Error: getting Maker deposit info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func getLidoDepositInfo() -> Promise<[GasInfo]> {
		if selectedToken.isEth {
			return getLidoETHDepositInfo()
		} else if selectedToken.isWEth {
			return getLidoWETHDepositInfo()
		} else {
			fatalError("Wrong token for lido investment")
		}
	}

	private func getLidoETHDepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
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
				seal.fulfill([depositResult.1])
			}.catch { error in
				print("W3 Error: getting Lido deposit info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func getLidoWETHDepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
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
				seal.fulfill([depositResult.1])
			}.catch { error in
				print("W3 Error: getting Lido deposit info: \(error)")
				seal.reject(error)
			}
		}
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

			web3Client.getHashTypedData(eip712HashReqInfo: hashREq.eip712HashReqBody).sink { completed in
				switch completed {
				case .finished:
					print("User hash received successfully")
				case let .failure(error):
					print("Error: getting user hash: \(error)")
					seal.reject(error)
				}
			} receiveValue: { hashResponse in
				seal.fulfill(hashResponse.hash)
			}.store(in: &cancellables)
		}
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> TrxWithGasInfo {
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
