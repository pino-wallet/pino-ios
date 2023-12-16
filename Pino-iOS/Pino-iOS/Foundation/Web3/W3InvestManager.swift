//
//  Web3InvestManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 10/9/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3InvestManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func getInvestProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.investContractAddress,
			abi: .invest,
			web3: readWeb3
		)
	}

	public func getCompoundProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.compoundContractAddress,
			abi: .investCompound,
			web3: readWeb3
		)
	}

	public func getCollateralCheckProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.compoundCollateralCheckContractAddress,
			abi: .compoundCollateralCheck,
			web3: readWeb3
		)
	}

	public func getCTokenProxyContract(cTokenID: String) throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: cTokenID,
			abi: .cToken,
			web3: readWeb3
		)
	}

	public func getAaveProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.aavePoolERCContractAddress,
			abi: .borrowERCAave,
			web3: readWeb3
		)
	}

	public func getDaiToSDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getInvestProxyContract()
			let solInvocation = contract[ABIMethodWrite.daiToSDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getSDaiToDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getInvestProxyContract()
			let solInvocation = contract[ABIMethodWrite.sDaiToDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.depositV2.rawValue]?(
				amount,
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositETHV2CallData(recipientAdd: String, proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.depositETHV2.rawValue]?(recipientAdd.eip55Address!, proxyFee)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.depositWETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.withdrawV2.rawValue]?(
				amount,
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawETHV2CallData(recipientAdd: String, amount: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.withdrawETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getCompoundProxyContract()
			let solInvocation = contract[ABIMethodWrite.withdrawWETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getETHToSTETHCallData(recipientAdd: String, proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getInvestProxyContract()
			let solInvocation = contract[ABIMethodWrite.ethToStETH.rawValue]?(recipientAdd.eip55Address!, proxyFee)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWETHToSTETHCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try getInvestProxyContract()
			let solInvocation = contract[ABIMethodWrite.wethToStETH.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getEnterMarketCallData(tokenAddress: String) -> Promise<EthereumData> {
		Promise<EthereumData>() { [self] seal in
			let contract = try getCollateralCheckProxyContract()
			let solInvocation = contract[ABIMethodWrite.enterMarkets.rawValue]?([tokenAddress.eip55Address!])
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data)
		}
	}

	public func getExitMarketCallData(tokenAddress: String) -> Promise<EthereumData> {
		Promise<EthereumData>() { [self] seal in
			let contract = try getCollateralCheckProxyContract()
			let solInvocation = contract[ABIMethodWrite.exitMarket.rawValue]?(tokenAddress.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data)
		}
	}

	public func getDisableCollateralCallData(tokenAddress: String) -> Promise<EthereumData> {
		Promise<EthereumData>() { [self] seal in
			let contract = try getAaveProxyContract()
			let solInvocation = contract[ABIMethodWrite.setUserUseReserveAsCollateral.rawValue]?(
				tokenAddress.eip55Address!,
				false
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data)
		}
	}

	public func getCheckMemebrshipCallData(accountAddress: String, tokenAddress: String) throws -> Promise<Bool> {
		let contract = try getCollateralCheckProxyContract()
		return Promise<Bool>() { seal in
			firstly {
				contract[ABIMethodCall.checkMembership.rawValue]!(
					accountAddress.eip55Address!,
					tokenAddress.eip55Address!
				).call()
			}.map { response in
				response[.emptyString] as! Bool
			}.done { membership in
				seal.fulfill(membership)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func getExchangeRateStoredCallData(cTokenID: String) throws -> Promise<BigUInt> {
		let contract = try getCTokenProxyContract(cTokenID: cTokenID)
		return Promise<BigUInt>() { seal in
			firstly {
				contract[ABIMethodCall.exchangeRateStored.rawValue]!().call()
			}.map { response in
				response[.emptyString] as! BigUInt
			}.done { exchangeRate in
				seal.fulfill(exchangeRate)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}
}
