//
//  W3GasInfo.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import BigInt
import Web3

public struct GasInfo {
    
    let gasPrice: BigUInt
    let gasLimit: BigUInt
    
    var increasedGasLimit: BigUInt {
        try! EthereumQuantity((gasLimit * BigUInt(110)) / BigUInt(100)).quantity
    }
    
    var fee: BigUInt {
        increasedGasLimit * gasPrice
    }
    
    var feeInDollar: BigNumber{
        let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
        let fee = BigNumber(unSignedNumber: fee, decimal: 18)
        return fee * eth!.price
    }
    
}

