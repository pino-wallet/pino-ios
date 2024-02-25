// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityWithdrawModel: ActivityInvestmentModelProtocol {
	var txHash: String
	var type: String
	var detail: InvestmentActivityDetails
	var fromAddress: String
	var toAddress: String
	var failed: Bool?
	var blockNumber: Int?
	var blockTime: String
	var gasUsed: String
	var gasPrice: String
	var prev_txHash: String?

	enum CodingKeys: String, CodingKey {
		case txHash = "tx_hash"
		case type, detail
		case fromAddress = "from_address"
		case toAddress = "to_address"
		case failed
		case blockNumber = "block_number"
		case blockTime = "block_time"
		case gasUsed = "gas_used"
		case gasPrice = "gas_price"
	}
}

extension ActivityWithdrawModel {
	init(cdWithDrawActivityModel: CDWithdrawActivity) {
		self.txHash = cdWithDrawActivityModel.txHash
		self.type = cdWithDrawActivityModel.type
		self.detail = InvestmentActivityDetails(
			tokens: cdWithDrawActivityModel.details.tokens.compactMap {
				ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
			},
			positionId: cdWithDrawActivityModel.details.poolID,
			activityProtocol: cdWithDrawActivityModel.details.activityProtocol,
			nftId: Int(cdWithDrawActivityModel.details.nftID)
		)
		self.fromAddress = cdWithDrawActivityModel.fromAddress
		self.toAddress = cdWithDrawActivityModel.toAddress
        switch ActivityStatus(rawValue: cdWithDrawActivityModel.status) {
        case .pending:
            self.failed = nil
        case .success:
            self.failed = false
        case .failed:
            self.failed = true
        default:
            self.failed = nil
        }
		self.blockNumber = nil
		self.blockTime = cdWithDrawActivityModel.blockTime
		self.gasUsed = cdWithDrawActivityModel.gasUsed
		self.gasPrice = cdWithDrawActivityModel.gasPrice
		self.prev_txHash = cdWithDrawActivityModel.prevTxHash
	}
}
