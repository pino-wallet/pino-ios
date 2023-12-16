//
//  W3CompoundRepayManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/13/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3CompoundRepayManager: Web3HelperProtocol {
    // MARK: - Internal Properties

    var writeWeb3: Web3
    var readWeb3: Web3

    // MARK: - Initializer

    init(writeWeb3: Web3, readWeb3: Web3) {
        self.readWeb3 = readWeb3
        self.writeWeb3 = writeWeb3
    }

    // MARK: - Public Methods

    public func getRepayERCCallData(
        contract: DynamicContract,
        cTokenAddress: String,
        amount: BigUInt
    ) -> Promise<String> {
        Promise<String> { seal in
            let solInvocation = contract[ABIMethodWrite.repayV2.rawValue]?(
                cTokenAddress.eip55Address!,
                amount,
                walletManager.currentAccount.eip55Address.eip55Address!
            )
            let trx = try trxManager.createTransactionFor(contract: solInvocation!)
            seal.fulfill(trx.data.hex())
        }
    }
    
    public func getRepayETHCallData(
        contract: DynamicContract,
        amount: BigUInt,
        proxyFee: BigUInt
    ) -> Promise<String> {
        Promise<String> { seal in
            let solInvocation = contract[ABIMethodWrite.repayETHV2.rawValue]?(
                amount,
                walletManager.currentAccount.eip55Address.eip55Address!,
                proxyFee
            )
            let trx = try trxManager.createTransactionFor(contract: solInvocation!)
            seal.fulfill(trx.data.hex())
        }
    }
}
