//
//  ActivityWrapETHModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 2/21/24.
//

import Foundation

struct ActivityWrapETHModel: ActivityModelProtocol {
    var txHash: String
    var type: String
    var fromAddress: String
    var toAddress: String
    var detail: ActivityWrapETHDetails
    var failed: Bool?
    var blockNumber: Int?
    var blockTime: String
    var gasUsed: String
    var gasPrice: String
    var prev_txHash: String?

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case type
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case detail
        case failed
        case blockNumber = "block_number"
        case blockTime = "block_time"
        case gasUsed = "gas_used"
        case gasPrice = "gas_price"
    }
}

struct ActivityWrapETHDetails: Codable {
    let amount: String
    
    enum CodingKeys: String, CodingKey {
        case amount
    }
}

extension ActivityWrapETHModel {
    init(cdApproveActivityModel: CDWrapETHActivity) {
        self.txHash = cdApproveActivityModel.txHash
        self.type = cdApproveActivityModel.type
        self.detail = ActivityWrapETHDetails(amount: cdApproveActivityModel.details.amount)
        self.fromAddress = cdApproveActivityModel.fromAddress
        self.toAddress = cdApproveActivityModel.toAddress
        self.failed = nil
        self.blockNumber = nil
        self.blockTime = cdApproveActivityModel.blockTime
        self.gasUsed = cdApproveActivityModel.gasUsed
        self.gasPrice = cdApproveActivityModel.gasPrice
        self.prev_txHash = cdApproveActivityModel.prevTxHash
    }
}
