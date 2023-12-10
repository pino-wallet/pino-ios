//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import BigInt
import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

enum Web3Error: Error {
	case invalidSmartContractAddress
	case failedTransaction
	case insufficientBalance
}

public class Web3Core {
	// MARK: - Private Properties

	private init() {}
	private var wWeb3: Web3 {
		Web3Network.writeRPC
	}

	private var rWeb3: Web3 {
		Web3Network.readRPC
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	private var trxManager: W3TransactionManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var gasInfoManager: W3GasInfoManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var transferManager: W3TransferManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var approveManager: W3ApproveManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var swapManager: W3SwapManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var investManager: W3InvestManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var compoundBorrowManager: W3CompoundBorrowManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var aaveBorrowManager: W3AaveBorrowManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var aaveDepositManager: W3AaveDepositManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var aaveWithdrawManager: W3AaveWithdrawManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private var aaveRepayManager: W3AaveRepayManager {
		.init(writeWeb3: wWeb3, readWeb3: rWeb3)
	}

	private let walletManager = PinoWalletManager()

	// MARK: - Typealias

	public typealias CustomAssetInfo = [ABIMethodCall: String]
	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Public Properties

	public static var shared = Web3Core()

	// MARK: - Public Methods

	public func getChecksumOfEip55Address(eip55Address: String) -> String {
		do {
			let ethAddress = try EthereumAddress(hex: eip55Address, eip55: false)
			return ethAddress.hex(eip55: true)
		} catch {
			fatalError("Cannot get checksum of wrong eip55 address")
		}
	}

	public func getAllowanceOf(
		contractAddress: String,
		spenderAddress: String,
		ownerAddress: String
	) throws -> Promise<BigUInt> {
		try callABIMethod(
			method: .allowance,
			abi: .erc,
			contractAddress: contractAddress.eip55Address!,
			params: ownerAddress.eip55Address!,
			spenderAddress.eip55Address!
		)
	}

	public func approveContract(contractDetails: ContractDetailsModel) -> Promise<String> {
		approveManager.approveContract(contractDetails: contractDetails)
	}

	public func getApproveContractDetails(
		address: String,
		amount: BigUInt,
		spender: String
	) -> Promise<ContractDetailsModel> {
		approveManager.getApproveContractDetails(address: address, amount: amount, spender: spender)
	}

	public func getApproveGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		approveManager.getApproveGasInfo(contractDetails: contractDetails)
	}

	public func getApproveCallData(contractAdd: String, amount: BigUInt, spender: String) -> Promise<String> {
		approveManager.getApproveCallData(contractAdd: contractAdd, amount: amount, spender: spender)
	}

	public func getApproveProxyCallData(contract: DynamicContract, tokenAdd: String, spender: String) -> Promise<String> {
		approveManager.getApproveProxyCallData(contract: contract, tokenAdd: tokenAdd, spender: spender)
	}

	public func getPermitTransferCallData(
		contract: DynamicContract,
		amount: BigUInt,
		tokenAdd: String,
		signiture: String,
		nonce: BigUInt,
		deadline: BigUInt
	) -> Promise<String> {
		transferManager.getPermitTransferFromCallData(
			contract: contract, amount: amount,
			tokenAdd: tokenAdd,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	public func getWrapETHCallData(contract: DynamicContract, proxyFee: BigUInt) -> Promise<String> {
		swapManager.getWrapETHCallData(contract: contract, proxyFee: proxyFee)
	}

	public func getUnwrapETHCallData(recipient: String) -> Promise<String> {
		swapManager.getUnWrapETHCallData(recipient: recipient)
	}

	public func getParaswapSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swapParaSwap)
	}

	public func getOneInchSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swapOneInch)
	}

	public func getZeroXSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swapZeroX)
	}

	public func getSweepTokenCallData(tokenAdd: String, recipientAdd: String) -> Promise<String> {
		swapManager.getSweepTokenCallData(tokenAdd: tokenAdd, recipientAdd: recipientAdd)
	}

	public func getSwapProxyContract() throws -> DynamicContract {
		try swapManager.getSwapProxyContract()
	}

	public func getPinoAaveProxyContract() throws -> DynamicContract {
		try aaveDepositManager.getPinoAaveProxyContract()
	}

	public func callMultiCall(
		contractAddress: String,
		callData: [String],
		value: BigUInt,
		nonce: EthereumQuantity? = nil
	) -> TrxWithGasInfo {
		let generatedMulticallData = W3CallDataGenerator.generateMultiCallFrom(calls: callData)
		let ethCallData = EthereumData(generatedMulticallData.hexToBytes())
		let eip55ContractAddress = contractAddress.eip55Address!

		return TrxWithGasInfo { [self] seal in

			gasInfoManager
				.calculateGasOf(data: ethCallData, to: eip55ContractAddress, value: value.etherumQuantity)
				.then { [self] gasInfo in
					guard let nonce else {
						return rWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
							.map { ($0, gasInfo) }
					}
					return nonce.promise.map { ($0, gasInfo) }
				}.done { [self] nonce, gasInfo in
					let trx = try trxManager.createTransactionFor(
						nonce: nonce,
						gasInfo: gasInfo,
						value: value.etherumQuantity,
						data: ethCallData,
						to: eip55ContractAddress
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
					seal.fulfill((signedTx, gasInfo))
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func getTransactionCallData(
		contractAddress: String,
		trxCallData: EthereumData,
		nonce: EthereumQuantity? = nil,
		value: BigUInt = 0
	) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		TrxWithGasInfo { [self] seal in
			gasInfoManager
				.calculateGasOf(data: trxCallData, to: contractAddress.eip55Address!, value: value.etherumQuantity)
				.then { [self] gasInfo in
					guard let nonce else {
						return rWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
							.map { ($0, gasInfo) }
					}
					return nonce.promise.map { ($0, gasInfo) }
				}.done { [self] nonce, gasInfo in
					let trx = try trxManager.createTransactionFor(
						nonce: nonce,
						gasInfo: gasInfo,
						value: value.etherumQuantity,
						data: trxCallData,
						to: contractAddress.eip55Address!
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
					seal.fulfill((signedTx, gasInfo))
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func getNonce() -> Promise<EthereumQuantity> {
		rWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
	}

	public func callTransaction(trx: EthereumSignedTransaction) -> Promise<String> {
		Promise<String> { seal in
			wWeb3.eth.sendRawTransaction(transaction: trx).done { signedData in
				seal.fulfill(signedData.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getCustomAssetInfo(contractAddress: String) -> Promise<CustomAssetInfo> {
		var assetInfo: CustomAssetInfo = [:]

		return Promise<CustomAssetInfo>() { seal in
			let _ = firstly {
				try rWeb3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
			}.then { conctractCode in
				if conctractCode.hex() == Constants.eoaCode {
					// In this case the smart contract belongs to an EOA
					throw Web3Error.invalidSmartContractAddress
				}
				return try self.getInfo(address: contractAddress, info: .decimal, abi: .erc)
			}.then { decimalValue in
				if String(describing: decimalValue[.emptyString]) == "0" {
					throw Web3Error.invalidSmartContractAddress
				}
				assetInfo[ABIMethodCall.decimal] = "\(decimalValue[String.emptyString]!)"
				return try self.getInfo(address: contractAddress, info: .name, abi: .erc).compactMap { nameValue in
					nameValue[String.emptyString] as? String
				}
			}.then { [self] nameValue -> Promise<[String: Any]> in
				assetInfo.updateValue(nameValue, forKey: ABIMethodCall.name)
				let contractAddress = try EthereumAddress(hex: contractAddress, eip55: true)
				let contract = rWeb3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
				return try contract
					.balanceOf(address: EthereumAddress(hex: walletManager.currentAccount.eip55Address, eip55: true))
					.call()
			}.map { balanceValue in
				balanceValue["_balance"] as! BigUInt
			}.then { balance in
				assetInfo.updateValue("\(balance)", forKey: ABIMethodCall.balance)
				return try self.getInfo(address: contractAddress, info: .symbol, abi: .erc).compactMap { symbolValue in
					symbolValue[String.emptyString] as? String
				}
			}.done { symbol in
				assetInfo.updateValue(symbol, forKey: ABIMethodCall.symbol)
				seal.fulfill(assetInfo)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func getETHBalance(of accountAddress: String) -> Promise<String> {
		Promise<String>() { seal in
			firstly {
				rWeb3.eth.getBalance(address: accountAddress.eip55Address!, block: .latest)
			}.map { balanceValue in
				BigNumber(unSignedNumber: balanceValue.quantity, decimal: 18)
			}.done { balance in
				seal.fulfill(balance.sevenDigitFormat.ethFormatting)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func calculateEthGasFee() -> GasInfo {
		gasInfoManager.calculateEthGasFee()
	}

	public func calculateSendERCGasFee(
		address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		gasInfoManager.calculateSendERCGasFee(
			recipient: address,
			amount: amount,
			tokenContractAddress: tokenContractAddress
		)
	}

	public func sendEtherTo(address: String, amount: BigUInt) -> TrxWithGasInfo {
		transferManager.getTrxOfsendEtherTo(recipient: address, amount: amount)
	}

	public func sendERC20TokenTo(
		recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> TrxWithGasInfo {
		transferManager.getTrxOfSendERC20TokenTo(
			recipientAddress: recipient,
			amount: amount,
			tokenContractAddress: tokenContractAddress
		)
	}

	public func getTransactionByHash(txHash: String) -> Promise<EthereumTransactionObject?> {
		Promise<EthereumTransactionObject?>() { seal in
			firstly {
				guard let txHashBytes = Data.fromHex(txHash) else {
					fatalError("cant get bytes from txHash string")
				}
				return rWeb3.eth.getTransactionByHash(blockHash: try EthereumData(txHashBytes))
			}.done { transactionObject in
				seal.fulfill(transactionObject)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func speedUpTransaction(tx: EthereumTransactionObject, newGasPrice: EthereumQuantity) -> Promise<String> {
		Promise<String>() { seal in
			let privateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
			firstly {
				var newTx = EthereumTransaction(
					nonce: tx.nonce,
					gasPrice: newGasPrice,
					to: tx.to,
					value: tx.value,
					data: tx.input
				)
				newTx.gasLimit = tx.gas
				newTx.transactionType = .legacy

				return try newTx.sign(with: privateKey, chainId: Web3Network.chainID).promise
			}.then { newTx in
				self.wWeb3.eth.sendRawTransaction(transaction: newTx)
			}.done { txHash in
				seal.fulfill(txHash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getGasPrice() -> Promise<EthereumQuantity> {
		Promise<EthereumQuantity>() { seal in
			firstly {
				rWeb3.eth.gasPrice()
			}.done { gasPrice in
				seal.fulfill(gasPrice)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getDaiToSDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getDaiToSDaiCallData(amount: amount, recipientAdd: recipientAdd)
	}

	public func getSDaiToDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getSDaiToDaiCallData(amount: amount, recipientAdd: recipientAdd)
	}

	public func getDepositV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getDepositV2CallData(tokenAdd: tokenAdd, amount: amount, recipientAdd: recipientAdd)
	}

	public func getDepositETHV2CallData(recipientAdd: String, proxyFee: BigUInt) -> Promise<String> {
		investManager.getDepositETHV2CallData(recipientAdd: recipientAdd, proxyFee: proxyFee)
	}

	public func getDepositWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getDepositWETHV2CallData(amount: amount, recipientAdd: recipientAdd)
	}

	public func getWithdrawV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getWithdrawV2CallData(tokenAdd: tokenAdd, amount: amount, recipientAdd: recipientAdd)
	}

	public func getWithdrawETHV2CallData(recipientAdd: String, amount: BigUInt) -> Promise<String> {
		investManager.getWithdrawETHV2CallData(recipientAdd: recipientAdd, amount: amount)
	}

	public func getWithdrawWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getWithdrawWETHV2CallData(amount: amount, recipientAdd: recipientAdd)
	}

	public func getETHToSTETHCallData(recipientAdd: String, proxyFee: BigUInt) -> Promise<String> {
		investManager.getETHToSTETHCallData(recipientAdd: recipientAdd, proxyFee: proxyFee)
	}

	public func getWETHToSTETHCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		investManager.getWETHToSTETHCallData(amount: amount, recipientAdd: recipientAdd)
	}

	public func getCompoundEnterMarketCallData(tokenAddress: String) -> Promise<EthereumData> {
		investManager.getEnterMarketCallData(tokenAddress: tokenAddress)
	}

	public func getCompoundExitMarketCallData(tokenAddress: String) -> Promise<EthereumData> {
		investManager.getExitMarketCallData(tokenAddress: tokenAddress)
	}

	public func getInvestProxyContract() throws -> DynamicContract {
		try investManager.getInvestProxyContract()
	}

	public func getCompoundProxyContract() throws -> DynamicContract {
		try investManager.getCompoundProxyContract()
	}

	public func getCompoundCollateralCheckProxyContract() throws -> DynamicContract {
		try investManager.getCollateralCheckProxyContract()
	}

	public func borrowCompoundCToken(contractDetails: ContractDetailsModel) -> Promise<String> {
		compoundBorrowManager.borrowCToken(contractDetails: contractDetails)
	}

	public func getCompoundBorrowCDaiContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCDaiContractDetails(amount: amount)
	}

	public func getCompoundBorrowCEthContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCEthContractDetails(amount: amount)
	}

	public func getCompoundBorrowCLinkContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCLinkContractDetails(amount: amount)
	}

	public func getCompoundBorrowCUsdcContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCUsdcContractDetails(amount: amount)
	}

	public func getCompoundBorrowCUsdtContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCUsdtContractDetails(amount: amount)
	}

	public func getCompoundBorrowCAaveContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCAaveContractDetails(amount: amount)
	}

	public func getCompoundBorrowCCompContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCCompContractDetails(amount: amount)
	}

	public func getCompoundBorrowCUniContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCUniContractDetails(amount: amount)
	}

	public func getCompoundBorrowCWbtcContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		compoundBorrowManager.getCWbtcContractDetails(amount: amount)
	}

	public func getCompoundBorrowCTokenGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		compoundBorrowManager.getCTokenBorrowGasInfo(contractDetails: contractDetails)
	}

	public func getAaveERCBorrowContractDetails(
		tokenID: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<ContractDetailsModel> {
		aaveBorrowManager.getERCBorrowContractDetails(tokenID: tokenID, amount: amount, userAddress: userAddress)
	}

	public func getAaveETHBorrowContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		aaveBorrowManager.getETHBorrowContractDetails(amount: amount)
	}

	public func getAaveERCBorrowGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		aaveBorrowManager.getERCBorrowGasInfo(contractDetails: contractDetails)
	}

	public func getAaveETHBorrowGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		aaveBorrowManager.getETHBorrowGasInfo(contractDetails: contractDetails)
	}

	public func getAaveERCBorrowTransaction(contractDetails: ContractDetailsModel)
		-> Promise<EthereumSignedTransaction> {
		aaveBorrowManager.getBorrowTransaction(contractDetails: contractDetails)
	}

	public func checkIfAssetUsedAsCollateral(assetAddress: String) -> Promise<Bool> {
		aaveDepositManager.checkIfAssetUsedAsCollateral(assetAddress: assetAddress)
	}

	public func getAaveDespositV3ERCCallData(
		contract: DynamicContract,
		assetAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		aaveDepositManager.getAaveDespositV3ERCCallData(
			contract: contract,
			assetAddress: assetAddress,
			amount: amount,
			userAddress: userAddress
		)
	}

	public func getUserUseReserveAsCollateralContractDetails(
		assetAddress: String,
		useAsCollateral: Bool
	) -> Promise<ContractDetailsModel> {
		aaveDepositManager.getUserUseReserveAsCollateralContractDetails(
			assetAddress: assetAddress,
			useAsCollateral: useAsCollateral
		)
	}

	public func getUserUseReserveAsCollateralGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		aaveDepositManager.getUserUseReserveAsCollateralGasInfo(contractDetails: contractDetails)
	}

	public func setUserUseReserveAsCollateral(contractDetails: ContractDetailsModel) -> Promise<String> {
		aaveDepositManager.setUserUseReserveAsCollateral(contractDetails: contractDetails)
	}

	public func getAaveWithdrawERCCallData(
		contract: DynamicContract,
		tokenAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		aaveWithdrawManager.getAaveWithdrawERCCallData(
			contract: contract,
			tokenAddress: tokenAddress,
			amount: amount,
			userAddress: userAddress
		)
	}

	public func getAaveUnwrapWETHCallData(contract: DynamicContract) -> Promise<String> {
		aaveWithdrawManager.getAaveUnwrapWethCallData(contract: contract)
	}

	public func getAaveWithdrawMaxERCContractDetails(tokenAddress: String) -> Promise<ContractDetailsModel> {
		aaveWithdrawManager.getWithdrawMAXERCContractDetails(tokenAddress: tokenAddress)
	}

	public func getAaveWithdrawMaxERCGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		aaveWithdrawManager.getWithdrawMaxERCGasInfo(contractDetails: contractDetails)
	}

	public func getAaveWithdrawMAXERCTransaction(contractDetails: ContractDetailsModel)
		-> Promise<EthereumSignedTransaction> {
		aaveWithdrawManager.getWithdrawMaxERCTransaction(contractDetails: contractDetails)
	}

	public func getCheckMembershipCallData(accountAddress: String, tokenAddress: String) throws -> Promise<Bool> {
		try investManager.getCheckMemebrshipCallData(accountAddress: accountAddress, tokenAddress: tokenAddress)
	}

	public func getAaveRepayERCCallData(
		contract: DynamicContract,
		tokenAddress: String,
		amount: BigUInt
	) -> Promise<String> {
		aaveRepayManager.getRepayERCCallData(contract: contract, tokenAddress: tokenAddress, amount: amount)
	}

	public func getExchangeRateStoredCallData(cTokenID: String) throws -> Promise<BigUInt> {
		try investManager.getExchangeRateStoredCallData(cTokenID: cTokenID)
	}

	// MARK: - Private Methods

	private func getInfo(address: String, info: ABIMethodCall, abi: Web3ABI) throws -> Promise<[String: Any]> {
		let contractAddress = try EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = abi.abi
		let contract = try rWeb3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract[info.rawValue]!(contractAddress).call()
	}

	private func callABIMethod<T, ABIParams: ABIEncodable>(
		method: ABIMethodCall,
		abi: Web3ABI,
		contractAddress: EthereumAddress,
		params: ABIParams...
	) throws -> Promise<T> {
		// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
		let contract = try rWeb3.eth.Contract(json: abi.abi, abiKey: nil, address: contractAddress)
		// Get balance of some address

		return Promise<T>() { seal in
			firstly {
				contract[method.rawValue]!(params).call()
			}.map { response in
				response[.emptyString] as! T
			}.done { allowance in
				seal.fulfill(allowance)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public static func getContractOfToken(
		address tokenContractAddress: String,
		abi: Web3ABI,
		web3: Web3
	) throws -> DynamicContract {
		let contractAddress = tokenContractAddress.eip55Address!
		let contractJsonABI = abi.abi
		// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
		let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract
	}
}

extension Web3Core {
	public enum Constants {
		static let ethGasLimit = "21000"
		static let eoaCode = "0x"
		static let permitAddress = "0x000000000022D473030F116dDEE9F6B43aC78BA3"
		static let pinoAaveProxyAddress = "0xb5ea6BAdD330466D66345e154Db9834B1Fe8Dab6"
		static let pinoSwapProxyAddress = "0xB51557272E09d41f649a04073dB780AC25998a1e"
		static let compoundContractAddress = "0xb5E69cBF92E3ff6c11E2CC4A33C26573702Ab98B"
		static let compoundCollateralCheckContractAddress = "0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B"
		static let investContractAddress = "0x7dA89F62340Ad976e4E32a30c7f688aFCcE8a51C"
		static let paraSwapETHID = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
		static let oneInchETHID = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
		static let zeroXETHID = "ETH"
		static let pinoETHID = "0x0000000000000000000000000000000000000000"
		static let wethTokenID = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
		static let aaveBorrowVariableInterestRate = 2
		static let aaveBorrowReferralCode = 0
		static let aavePoolERCContractAddress = "0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2"
		static let aaveWrappedTokenETHContractAddress = "0xD322A49006FC828F9B5B37Ab215F99B4E5caB19C"
		static let compoundCAaveContractAddress = "0xe65cdB6479BaC1e22340E4E755fAE7E509EcD06c"
		static let compoundCCompContractAddress = "0x70e36f6BF80a52b3B46b3aF8e106CC0ed743E8e4"
		static let compoundCDaiContractAddress = "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643"
		static let compoundCEthContractAddress = "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5"
		static let compoundCLinkContractAddress = "0xFAce851a4921ce59e912d19329929CE6da6EB0c7"
		static let compoundCUniContractAddress = "0x35A18000230DA775CAc24873d00Ff85BccdeD550"
		static let compoundCUsdcContractAddress = "0x39AA39c021dfbaE8faC545936693aC917d5E7563"
		static let compoundCUsdtContractAddress = "0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9"
		static let compoundCWbtcContractAddress = "0xC11b1268C1A384e55C48c2391d8d480264A3A7F4"
		static let sDaiContractAddress = "0x83f20f44975d03b1b09e64809b757c47f942beea"
	}
}

extension Web3Core {
	public enum TokenID: String {
		case aave = "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9"
		case dai = "0x6b175474e89094c44da98b954eedeac495271d0f"
		case eth = "0x0000000000000000000000000000000000000000"
		case link = "0x514910771af9ca656af840dff83e8264ecf986ca"
		case uni = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"
		case usdc = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
		case usdt = "0xdac17f958d2ee523a2206206994597c13d831ec7"
		case wbtc = "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"

		// MARK: Public Properties

		public var cTokenID: String {
			switch self {
			case .aave:
				return "0xe65cdB6479BaC1e22340E4E755fAE7E509EcD06c"
			case .dai:
				return "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643"
			case .eth:
				return "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5"
			case .link:
				return "0xFAce851a4921ce59e912d19329929CE6da6EB0c7"
			case .uni:
				return "0x35A18000230DA775CAc24873d00Ff85BccdeD550"
			case .usdc:
				return "0x39AA39c021dfbaE8faC545936693aC917d5E7563"
			case .usdt:
				return "0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9"
			case .wbtc:
				return "0xC11b1268C1A384e55C48c2391d8d480264A3A7F4"
			}
		}

		// MARK: Initializers

		init(id: String) {
			self = TokenID(rawValue: id)!
		}
	}
}
