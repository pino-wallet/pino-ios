//
//  CompoundDepositManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/12/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class CompoundDepositManager: InvestW3ManagerProtocol {
	// MARK: - Private Properties

	private var investAmount: String
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)!
	}

	// MARK: - Public Properties

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

	init(contract: DynamicContract, selectedToken: AssetViewModel, investAmount: String) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.investAmount = investAmount
		self.selectedProtocol = .compound
	}

	// MARK: Public Methods

	public func getDepositInfo() -> TrxWithGasInfo {
		if selectedToken.isEth {
			return compoundETHDeposit()
		} else if selectedToken.isWEth {
			return compoundWETHDeposit()
		} else {
			return compoundERCDeposit()
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

	private func compoundERCDeposit() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { [self] signiture -> Promise<(String, String)> in
				// Check allowance of protocol
				checkAllowanceOfProvider(
					approvingToken: selectedToken,
					approvingAmount: investAmount,
					spenderAddress: tokenPositionID,
					ownerAddress: Web3Core.Constants.compoundContractAddress
				).map { (signiture, $0!) }
			}.then { signiture, allowanceData -> Promise<(String, String)> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { [self] permitData, allowanceData -> Promise<(String, String, String)> in
				web3.getDepositV2CallData(
					tokenAdd: tokenPositionID,
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData, allowanceData) }
			}.then { protocolCallData, permitData, allowanceData in
				// MultiCall
				let callDatas = [allowanceData, permitData, protocolCallData]
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

	private func compoundETHDeposit() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			let proxyFee = 0.bigNumber.bigUInt
			firstly {
				self.web3.getDepositETHV2CallData(
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

	private func compoundWETHDeposit() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getDepositWETHV2CallData(
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

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: selectedToken.id,
				amount: tokenUIntNumber.description,
				spender: Web3Core.Constants.compoundContractAddress,
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
			tokenAdd: selectedToken.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}
}
