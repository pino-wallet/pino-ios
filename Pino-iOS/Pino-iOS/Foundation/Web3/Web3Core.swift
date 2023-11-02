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
	private var web3: Web3 {
		if let testURL = AboutPinoView.web3URL {
			return Web3(rpcURL: testURL)
		} else {
			return Web3Network.rpc
		}
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	private var trxManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var transferManager: W3TransferManager {
		.init(web3: web3)
	}

	private var approveManager: W3ApproveManager {
		.init(web3: web3)
	}

	private var swapManager: W3SwapManager {
		.init(web3: web3)
	}

	private var investManager: W3InvestManager {
		.init(web3: web3)
	}

	private var compoundBorrowManager: W3CompoundBorrowManager {
		.init(web3: web3)
	}

	private var aaveBorrowManager: W3AaveBorrowManager {
		.init(web3: web3)
	}

	private var aaveDepositManager: W3AaveDepositManager {
		.init(web3: web3)
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
		swapManager.getSwapProviderData(callData: data, method: .swapParaswap)
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

	public func callMultiCall(contractAddress: String, callData: [String], value: BigUInt) -> TrxWithGasInfo {
		let generatedMulticallData = W3CallDataGenerator.generateMultiCallFrom(calls: callData)
		let ethCallData = EthereumData(generatedMulticallData.hexToBytes())
		let eip55ContractAddress = contractAddress.eip55Address!

		return TrxWithGasInfo { [self] seal in

			gasInfoManager
				.calculateGasOf(data: ethCallData, to: eip55ContractAddress, value: value.etherumQuantity)
				.then { [self] gasInfo in
					web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
						.map { ($0, gasInfo) }
				}.done { [self] nonce, gasInfo in
					let trx = try trxManager.createTransactionFor(
						nonce: nonce,
						gasPrice: gasInfo.gasPrice.etherumQuantity,
						gasLimit: gasInfo.increasedGasLimit.bigUInt.etherumQuantity,
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

	public func callTransaction(trx: EthereumSignedTransaction) -> Promise<String> {
		Promise<String> { seal in
			web3.eth.sendRawTransaction(transaction: trx).done { signedData in
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
				try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
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
				let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
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
				web3.eth.getBalance(address: accountAddress.eip55Address!, block: .latest)
			}.map { balanceValue in
				BigNumber(unSignedNumber: balanceValue.quantity, decimal: 18)
			}.done { balance in
				seal.fulfill(balance.sevenDigitFormat.ethFormatting)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func calculateEthGasFee() -> Promise<GasInfo> {
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

	public func sendEtherTo(address: String, amount: BigUInt) -> Promise<String> {
		transferManager.sendEtherTo(recipient: address, amount: amount)
	}

	public func sendERC20TokenTo(
		recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<String> {
		transferManager.sendERC20TokenTo(
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
				return web3.eth.getTransactionByHash(blockHash: try EthereumData(txHashBytes))
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
				self.web3.eth.sendRawTransaction(transaction: newTx)
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
				web3.eth.gasPrice()
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

	public func aaveBorrowToken(contractDetails: ContractDetailsModel) -> Promise<String> {
		aaveBorrowManager.borrowToken(contractDetails: contractDetails)
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

	// MARK: - Private Methods

	private func getInfo(address: String, info: ABIMethodCall, abi: Web3ABI) throws -> Promise<[String: Any]> {
		let contractAddress = try EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = abi.abi
		let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract[info.rawValue]!(contractAddress).call()
	}

	private func callABIMethod<T, ABIParams: ABIEncodable>(
		method: ABIMethodCall,
		abi: Web3ABI,
		contractAddress: EthereumAddress,
		params: ABIParams...
	) throws -> Promise<T> {
		// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
		let contract = try web3.eth.Contract(json: abi.abi, abiKey: nil, address: contractAddress)
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
	}
}
