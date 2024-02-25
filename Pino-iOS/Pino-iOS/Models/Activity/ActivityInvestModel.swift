// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityInvestModel: ActivityInvestmentModelProtocol {
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

extension ActivityInvestModel {
	init(cdInvestActivityModel: CDInvestActivity) {
		self.txHash = cdInvestActivityModel.txHash
		self.type = cdInvestActivityModel.type
		self.detail = InvestmentActivityDetails(
			tokens: cdInvestActivityModel.details.tokens.compactMap {
				ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
			},
			positionId: cdInvestActivityModel.details.poolID,
			activityProtocol: cdInvestActivityModel.details.activityProtocol,
			nftId: Int(cdInvestActivityModel.details.nftID)
		)
		self.fromAddress = cdInvestActivityModel.fromAddress
		self.toAddress = cdInvestActivityModel.toAddress
        switch ActivityStatus(rawValue: cdInvestActivityModel.status) {
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
		self.blockTime = cdInvestActivityModel.blockTime
		self.gasUsed = cdInvestActivityModel.gasUsed
		self.gasPrice = cdInvestActivityModel.gasPrice
		self.prev_txHash = cdInvestActivityModel.prevTxHash
	}
}
