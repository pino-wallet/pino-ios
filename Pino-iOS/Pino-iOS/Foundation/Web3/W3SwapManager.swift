//
//  W3TransferManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3SwapManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var walletManager = PinoWalletManager()
	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var trxManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	// MARK: - Public Methods

	public func getSweepTokenCallData(tokenAdd: String, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.sweepToken.rawValue]?(
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getWrapETHCallData(proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.wrapETH.rawValue]?(proxyFee)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getUnWrapETHCallData(recipient: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(recipient.eip55Address!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func callMultiCall(callData: [String], value: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)

			let dataOfCallData = callData.map { callData in
                Data(hexString: callData, length: UInt(callData.count))!
			}
            
            let calls = "0x35471101000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000001000000000000000000000000216b4b4ba9f3e719726886d34a177484278bfcae"
            let multiArray: Array<Data> = Array(hexString: calls, length: 1)!
            
            let multicall = Multicall(callData: callData)
            
            let solInvocation = contract[ABIMethodWrite.multicall.rawValue]?(multiArray)

            let trx = try trxManager.createTransactionFor(
                contract: solInvocation!,
                nonce: BigUInt(123).etherumQuantity,
                gasPrice: BigUInt(123).etherumQuantity,
                gasLimit: BigUInt(123000).etherumQuantity,
                value: BigUInt(0).etherumQuantity
            )
            
            let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
            print(signedTx.data.hex())
            print(callData.first!.hexToBytes())
            print(Data(callData.first!.hexToBytes()))
            
			gasInfoManager.calculateGasOf(
				method: .multicall,
				solInvoc: solInvocation!,
				contractAddress: contract.address!
			)
			.then { [self] gasInfo in
				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.then { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: solInvocation!,
					nonce: nonce,
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.gasLimit.etherumQuantity,
					value: value.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
				return "hash".promise
//				return web3.eth.sendRawTransaction(transaction: signedTx)
			}.done { txHash in
				seal.fulfill(txHash)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getSwapProviderData(callData: String, method: ABIMethodWrite) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)

			// Remove the "0x" prefix if present
			let cleanedHexString = callData.hasPrefix("0x") ? String(callData.dropFirst(2)) : callData

			// Calculate the length in characters
			let lengthInCharacters = cleanedHexString.count

			// Calculate the length in bytes
			let lengthInBytes = lengthInCharacters / 2

			let callD = Data(hexString: callData, length: UInt(lengthInBytes))
			//            let callD2 = Data(callData.hexToBytes())
			//            let str = String.init(data: callD!, encoding: .utf8)!

			let solInvocation = contract[method.rawValue]?(callD!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}
}

struct Multicall: ABIEncodable {
    var callData: [String] // Array of hex strings
    
    func abiEncode(dynamic: Bool) -> String? {
        var encoded = "" // Initial empty string to accumulate the encoding
        
        // Encode the length of the array
        encoded += UInt64(callData.count).abiEncode(dynamic: false) ?? ""
        
        // Calculate the offset to the dynamic data
        // For each element in the array, there is one word (32 bytes) offset
        var offset = 32 * callData.count
        
        // Array to hold the encoded dynamic data
        var dynamicDataEncoded = ""
        
        for dataHex in callData {
            // Assuming dataHex is a valid hex string, e.g. "0x1234"
//            guard let data = Data(hexString: dataHex) else {
//                // Handle invalid hex string
//                return nil
//            }
            
            let data = Data(hex: dataHex)
            
            // Encode the offset
            encoded += UInt64(offset).abiEncode(dynamic: false) ?? ""
            
            // Encode the length of the bytes
            dynamicDataEncoded += UInt64(data.count).abiEncode(dynamic: false) ?? ""
            
            // Encode the actual bytes
            dynamicDataEncoded += data.map { String(format: "%02x", $0) }.joined()
            
            // Update the offset for the next element
            // Each word is 32 bytes. The length of the bytes takes one word.
            // The data takes (length + 31) / 32 words.
            offset += 32 * ((data.count + 31) / 32 + 1)
        }
        
        // Combine the encoding of offsets and the encoding of dynamic data
        encoded += dynamicDataEncoded
        
        return encoded
    }
}

extension ABIDecodable {
    init?(hexString: String, length: Int) {
        
    }
}


extension Array: ABIDecodable where Element: ABIDecodable {
    
    public init?(hexString: String) {
        let lengthString = hexString.substr(0, 64)
        let valueString = String(hexString.dropFirst(64))
        guard let string = lengthString, let length = Int(string, radix: 16), length > 0 else { return nil }
        self.init(hexString: valueString, length: length)
    }
    
    public init?(hexString: String, length: Int) {
        let itemLength = hexString.count / length
        let values = (0..<length).compactMap { i -> Element? in
            if let elementString = hexString.substr(i * itemLength, itemLength) {
                return Element.init(hexString: elementString, length: itemLength)
            }
            return nil
        }
        if values.count == length {
            self = values
        } else {
            return nil
        }
    }
    
}
