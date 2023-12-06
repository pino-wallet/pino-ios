//
//  CompoundWithdrawManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/27/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class CompoundWithdrawManager: InvestW3ManagerProtocol {
	// MARK: - Private Properties

	private var withdrawAmount: String
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private var tokenUIntNumber: BigUInt

	// MARK: - Public Properties

	public var withdrawTrx: EthereumSignedTransaction?
	public var withdrawGasInfo: GasInfo?
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
		withdrawAmount: String
	) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.selectedProtocol = .compound
		self.withdrawAmount = withdrawAmount
		self.tokenUIntNumber = Utilities.parseToBigUInt(withdrawAmount, decimals: selectedToken.decimal)!
	}

	// MARK: Public Methods

	public func getWithdrawInfo() -> TrxWithGasInfo {
		if selectedToken.isEth {
			return getCompoundETHWithdrawInfo()
		} else if selectedToken.isWEth {
			return getCompoundWETHWithdrawInfo()
		} else {
			return getCompoundERCWithdrawInfo()
		}
	}

	// MARK: - Private Methods

	private func getCompoundERCWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				try self.web3.getExchangeRateStoredCallData(cTokenID: positionID)
			}.then { [self] exchangeRate in
				tokenUIntNumber = tokenUIntNumber * BigUInt(10).power(18) / exchangeRate
				return fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData in
				web3.getWithdrawV2CallData(
					tokenAdd: tokenPositionID,
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData) }
			}.then { protocolCallData, permitData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { withdrawResult in
				self.withdrawTrx = withdrawResult.0
				self.withdrawGasInfo = withdrawResult.1
				seal.fulfill(withdrawResult)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getCompoundETHWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				try self.web3.getExchangeRateStoredCallData(cTokenID: positionID)
			}.then { [self] exchangeRate in
				tokenUIntNumber = tokenUIntNumber * BigUInt(10).power(18) / exchangeRate
				return fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData in
				web3.getWithdrawETHV2CallData(
					recipientAdd: walletManager.currentAccount.eip55Address,
					amount: tokenUIntNumber
				).map { (permitData, $0) }
			}.then { permitData, protocolCallData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { withdrawResult in
				self.withdrawTrx = withdrawResult.0
				self.withdrawGasInfo = withdrawResult.1
				seal.fulfill(withdrawResult)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getCompoundWETHWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				try self.web3.getExchangeRateStoredCallData(cTokenID: positionID)
			}.then { [self] exchangeRate in
				tokenUIntNumber = tokenUIntNumber * BigUInt(10).power(18) / exchangeRate
				return fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getWithdrawWETHV2CallData(
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { (permitData, $0) }
			}.then { permitData, protocolCallData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { withdrawResult in
				self.withdrawTrx = withdrawResult.0
				self.withdrawGasInfo = withdrawResult.1
				seal.fulfill(withdrawResult)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in
			let hashREq = EIP712HashRequestModel(
				tokenAdd: tokenPositionID,
				amount: tokenUIntNumber.description,
				spender: contract.address!.hex(eip55: true),
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
			tokenAdd: tokenPositionID,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}
}
