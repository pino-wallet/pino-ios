//
//  Web3Manager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 10/20/23.
//

import Foundation
import PromiseKit
import Web3
import Web3_Utility

protocol Web3ManagerProtocol {
	typealias CallData = String

	var web3: Web3Core { get set }
	var walletManager: PinoWalletManager { get set }
	func wrapTokenCallData() -> Promise<CallData>
	func unwrapToken() -> Promise<CallData?>
	func getProxyPermitTransferData(signiture: String) -> Promise<CallData>
	func checkAllowanceOfProvider(
		approvingToken: AssetViewModel,
		approvingAmount: String,
		spenderAddress: String,
		ownerAddress: String
	) -> Promise<CallData?>
	func sweepToken(tokenAddress: String) -> Promise<CallData?>
	func signHash(plainHash: String) -> Promise<CallData>
}

extension Web3ManagerProtocol {
	func unwrapToken() -> Promise<String?> {
		Promise<String?>() { seal in
			web3.getUnwrapETHCallData(recipient: walletManager.currentAccount.eip55Address)
				.done { wrapData in
					seal.fulfill(wrapData)
				}.catch { error in
					print(error)
				}
		}
	}

	func sweepToken(tokenAddress: String) -> Promise<CallData?> {
		Promise<String?>() { seal in
			web3.getSweepTokenCallData(
				tokenAdd: tokenAddress,
				recipientAdd: walletManager.currentAccount.eip55Address
			).done { sweepData in
				seal.fulfill(sweepData)
			}.catch { error in
				seal.reject(error)
				print(error)
			}
		}
	}

	func wrapTokenCallData() -> Promise<String> {
		web3.getWrapETHCallData(proxyFee: 0)
	}

	func checkAllowanceOfProvider(
		approvingToken: AssetViewModel,
		approvingAmount: String,
		spenderAddress: String,
		ownerAddress: String = Web3Core.Constants.pinoProxyAddress
	) -> Promise<String?> {
		Promise<String?> { seal in
			firstly {
				try web3.getAllowanceOf(
					contractAddress: approvingToken.id,
					spenderAddress: spenderAddress,
					ownerAddress: ownerAddress
				)
			}.done { [self] allowanceAmount in
				let approvingTokenAmount = Utilities.parseToBigUInt(approvingAmount, decimals: approvingToken.decimal)!
				if allowanceAmount == 0 || allowanceAmount < approvingTokenAmount {
					web3.getApproveProxyCallData(
						tokenAdd: approvingToken.id,
						spender: spenderAddress
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

	func signHash(plainHash: String) -> Promise<String> {
		Promise<String> { seal in
			var signiture = try Sec256k1Encryptor.sign(
				msg: plainHash.hexToBytes(),
				seckey: walletManager.currentAccountPrivateKey.string.hexToBytes()
			)
			signiture[signiture.count - 1] += 27

			seal.fulfill("0x\(signiture.toHexString())")
		}
	}
}