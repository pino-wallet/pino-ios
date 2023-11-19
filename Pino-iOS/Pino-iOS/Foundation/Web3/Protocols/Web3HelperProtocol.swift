//
//  Web3HelperProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/19/23.
//

import Foundation
import Web3

protocol Web3HelperProtocol {
    var writeWeb3: Web3 { get set }
    var readWeb3: Web3 { get set }
    init(writeWeb3: Web3, readWeb3: Web3)
    var gasInfoManager: W3GasInfoManager { get }
    var trxManager: W3TransactionManager { get }
    var transferManager: W3TransferManager { get }
    var walletManager: PinoWalletManager { get }
    var userPrivateKey: EthereumPrivateKey { get }
}

extension Web3HelperProtocol {
    var gasInfoManager: W3GasInfoManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var trxManager: W3TransactionManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var transferManager: W3TransferManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var walletManager: PinoWalletManager {
        PinoWalletManager()
    }
    
    var userPrivateKey: EthereumPrivateKey {
        try! EthereumPrivateKey(
            hexPrivateKey: walletManager.currentAccountPrivateKey
                .string
        )
    }
}
