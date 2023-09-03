//
//  RepayConfirmViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Foundation

#warning("this values are static and should be changed")

struct RepayConfirmViewModel {
    // MARK: - Public Properties

    public let pageTitle = "Confirm repayment"
    public let protocolTitle = "Protocol"
    public let feeTitle = "Fee"
    public let confirmButtonTitle = "Confirm"
    #warning("this actionsheet texts are for test")
    public let feeActionSheetText = "this is fee"
    public let protocolActionsheetText = "this is protocol"
    #warning("this fee is mock and it should be removed")
    public let fee = "$10"

    public var protocolImageName: String {
        "aave"
    }

    public var protocolName: String {
        "Aave"
    }

    public var tokenAmountAndSymbol: String {
        "120 USDC"
    }

    public var tokenAmountInDollars: String {
        "$120"
    }

    public var tokenImage: String {
        "USDC"
    }
}
