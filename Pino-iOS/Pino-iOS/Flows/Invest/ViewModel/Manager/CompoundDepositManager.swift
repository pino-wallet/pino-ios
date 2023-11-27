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
	private let depositType: DepositType
	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)!
	}

	// MARK: - Public Properties

	public var depositTrx: EthereumSignedTransaction?
	public var depositGasInfo: GasInfo?
	public var collateralCheckTrx: EthereumSignedTransaction?
	public var collateralCheckGasInfo: GasInfo?
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

	init(contract: DynamicContract, selectedToken: AssetViewModel, investAmount: String, type: DepositType) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.investAmount = investAmount
		self.selectedProtocol = .compound
		self.depositType = type
	}

	// MARK: Public Methods

	public func getDepositInfo() -> Promise<[GasInfo]> {
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
			guard let collateralCheckTrx = self.collateralCheckTrx else {
				completion(.fulfilled(trxHash))
				return
			}
			Web3Core.shared.callTransaction(trx: collateralCheckTrx).done { trxHash in
				completion(.fulfilled(trxHash))
			}.catch { error in
				completion(.rejected(error))
			}
		}.catch { error in
			completion(.rejected(error))
		}
	}

	// MARK: - Private Methods

	private func compoundERCDeposit() -> Promise<[GasInfo]> {
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
					ownerAddress: Web3Core.Constants.compoundContractAddress
				).map { (signiture, $0) }
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
				web3.getDepositV2CallData(
					tokenAdd: tokenPositionID,
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData, allowanceData) }
			}
			.then { protocolCallData, permitData, allowanceData -> Promise<(String, String, String?, EthereumQuantity)> in
				self.web3.getNonce().map { (protocolCallData, permitData, allowanceData, $0) }
			}.then { protocolCallData, permitData, allowanceData, trxNonce in
				// MultiCall
				var callDatas = [permitData, protocolCallData]
				if let allowanceData {
					callDatas.insert(allowanceData, at: 0)
				}
				return self.callProxyMultiCall(data: callDatas, value: nil, trxNonce: trxNonce).map { (trxNonce, $0) }
			}.then { trxNonce, depositResult -> Promise<((EthereumSignedTransaction, GasInfo), GasInfo?)> in
				self.checkMembership(trxNonce: trxNonce).map { (depositResult, $0) }
			}.done { depositResult, exitMarketGas in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				if let exitMarketGas {
					seal.fulfill([depositResult.1, exitMarketGas])
				} else {
					seal.fulfill([depositResult.1])
				}
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func compoundETHDeposit() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			let proxyFee = 0.bigNumber.bigUInt
			firstly {
				getTokenPositionID()
			}.then { [self] positionID in
				web3.getDepositETHV2CallData(
					recipientAdd: walletManager.currentAccount.eip55Address,
					proxyFee: proxyFee
				)
			}.then { protocolCallData in
				self.web3.getNonce().map { (protocolCallData, $0) }
			}.then { protocolCallData, trxNonce in
				// MultiCall
				let callDatas = [protocolCallData]
				let ethDepositAmount = self.tokenUIntNumber + proxyFee
				return self.callProxyMultiCall(data: callDatas, value: ethDepositAmount, trxNonce: trxNonce)
					.map { (trxNonce, $0) }
			}.then { trxNonce, depositResult -> Promise<((EthereumSignedTransaction, GasInfo), GasInfo?)> in
				self.checkMembership(trxNonce: trxNonce).map { (depositResult, $0) }
			}.done { depositResult, exitMarketGas in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				if let exitMarketGas {
					seal.fulfill([depositResult.1, exitMarketGas])
				} else {
					seal.fulfill([depositResult.1])
				}
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func compoundWETHDeposit() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.fetchHash()
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
				self.web3.getNonce().map { (protocolCallData, permitData, $0) }
			}.then { protocolCallData, permitData, trxNonce in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil, trxNonce: trxNonce).map { (trxNonce, $0) }
			}.then { trxNonce, depositResult -> Promise<((EthereumSignedTransaction, GasInfo), GasInfo?)> in
				self.checkMembership(trxNonce: trxNonce).map { (depositResult, $0) }
			}.done { depositResult, exitMarketGas in
				self.depositTrx = depositResult.0
				self.depositGasInfo = depositResult.1
				if let exitMarketGas {
					seal.fulfill([depositResult.1, exitMarketGas])
				} else {
					seal.fulfill([depositResult.1])
				}
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func checkMembership(trxNonce: EthereumQuantity) -> Promise<GasInfo?> {
		switch depositType {
		case .invest:
			return checkMembershipForInvest(trxNonce: trxNonce)
		case .collateral:
			return checkMembershipForCollateral(trxNonce: trxNonce)
		}
	}

	private func checkMembershipForInvest(trxNonce: EthereumQuantity) -> Promise<GasInfo?> {
		Promise<GasInfo?> { seal in
			firstly {
				try web3.getCheckMembershipCallData(
					accountAddress: walletManager.currentAccount.eip55Address,
					tokenAddress: self.tokenPositionID
				)
			}.done { hasMembership in
				if hasMembership {
					self.getExitMarketInfo(trxNonce: EthereumQuantity(quantity: trxNonce.quantity + 1))
						.done { [self] exitMarketResult in
							collateralCheckTrx = exitMarketResult.0
							collateralCheckGasInfo = exitMarketResult.1
							seal.fulfill(collateralCheckGasInfo!)
						}.catch { error in
							seal.reject(error)
						}
				} else {
					seal.fulfill(nil)
				}
			}.catch { error in
				print(error)
				seal.reject(error)
			}
		}
	}

	private func checkMembershipForCollateral(trxNonce: EthereumQuantity) -> Promise<GasInfo?> {
		Promise<GasInfo?> { seal in
			firstly {
				try web3.getCheckMembershipCallData(
					accountAddress: walletManager.currentAccount.eip55Address,
					tokenAddress: self.tokenPositionID
				)
			}.done { hasMembership in
				if !hasMembership {
					self.getEnterMarketInfo(trxNonce: EthereumQuantity(quantity: trxNonce.quantity + 1))
						.done { [self] enterMarketResult in
							collateralCheckTrx = enterMarketResult.0
							collateralCheckGasInfo = enterMarketResult.1
							seal.fulfill(collateralCheckGasInfo!)
						}.catch { error in
							seal.reject(error)
						}
				} else {
					seal.fulfill(nil)
				}
			}.catch { error in
				print(error)
				seal.reject(error)
			}
		}
	}

	private func getEnterMarketInfo(trxNonce: EthereumQuantity) -> TrxWithGasInfo {
		firstly {
			self.web3.getCompoundEnterMarketCallData(tokenAddress: tokenPositionID)
		}.then { trxCallData in
			let collateralCheckContract = try self.web3.getCompoundCollateralCheckProxyContract()
			return self.web3.getTransactionCallData(
				contractAddress: collateralCheckContract.address!.hex(eip55: true),
				trxCallData: trxCallData,
				nonce: trxNonce
			)
		}
	}

	private func getExitMarketInfo(trxNonce: EthereumQuantity) -> TrxWithGasInfo {
		firstly {
			self.web3.getCompoundExitMarketCallData(tokenAddress: tokenPositionID)
		}.then { trxCallData in
			let collateralCheckContract = try self.web3.getCompoundCollateralCheckProxyContract()
			return self.web3.getTransactionCallData(
				contractAddress: collateralCheckContract.address!.hex(eip55: true),
				trxCallData: trxCallData,
				nonce: trxNonce
			)
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

	private func callProxyMultiCall(
		data: [String],
		value: BigUInt?,
		trxNonce: EthereumQuantity? = nil
	) -> TrxWithGasInfo {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt,
			nonce: trxNonce
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

enum DepositType {
	case invest
	case collateral
}
