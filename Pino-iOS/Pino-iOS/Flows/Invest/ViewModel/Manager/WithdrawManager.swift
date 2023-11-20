//
//  WithdrawManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class WithdrawManager: Web3ManagerProtocol {
	// MARK: - Private Properties

	private var withdrawProtocol: InvestProtocolViewModel
	private var withdrawAmount: String
	private let selectedToken: AssetViewModel
	private let tokenAddress: String
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private let web3Client = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()

	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(withdrawAmount, decimals: selectedToken.decimal)!
	}

	// MARK: - Public Properties

	public var withdrawTrx: EthereumSignedTransaction?
	public var withdrawGasInfo: GasInfo?
	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Internal properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: Initializers

	init(
		contract: DynamicContract,
		selectedToken: AssetViewModel,
		withdrawProtocol: InvestProtocolViewModel,
		withdrawAmount: String
	) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.withdrawProtocol = withdrawProtocol
		self.withdrawAmount = withdrawAmount
		self.tokenAddress = selectedToken.id
	}

	// MARK: Public Methods

	public func getWithdrawInfo() -> TrxWithGasInfo? {
		switch withdrawProtocol {
		case .maker:
			return getMakerWithdrawInfo()
		case .compound:
			return getCompoundWithdrawInfo()
		case .lido:
			return getLidoWithdrawInfo()
		case .aave:
			return nil
		case .balancer, .uniswap:
			return nil
		}
	}

	public func confirmWithdraw(completion: @escaping (Result<String>) -> Void) {
		guard let withdrawTrx else { return }
		Web3Core.shared.callTransaction(trx: withdrawTrx).done { trxHash in
			#warning("Add transaction activity later")
			completion(.fulfilled(trxHash))
		}.catch { error in
			completion(.rejected(error))
		}
	}

	// MARK: - Private Methods

	private func getMakerWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getSDaiToDaiCallData(
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
	}

	private func getLidoWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
		}
	}

	private func getCompoundWithdrawInfo() -> TrxWithGasInfo {
		if selectedToken.isEth {
			return getCompoundETHWithdrawInfo()
		} else if selectedToken.isWEth {
			return getCompoundWETHWithdrawInfo()
		} else {
			return getCompoundERCWithdrawInfo()
		}
	}

	private func getCompoundERCWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			let cTokenID = Web3Core.TokenID(id: selectedToken.id).cTokenID
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData in
				web3.getWithdrawV2CallData(
					tokenAdd: cTokenID,
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
	}

	private func getCompoundETHWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				self.web3.getWithdrawETHV2CallData(
					recipientAdd: walletManager.currentAccount.eip55Address,
					amount: tokenUIntNumber
				)
			}.then { protocolCallData in
				// MultiCall
				let callDatas = [protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { trxHash in
				print(trxHash)
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func getCompoundWETHWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getWithdrawWETHV2CallData(
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
