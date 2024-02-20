// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityRepayModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: RepayActivityDetails
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

struct RepayActivityDetails: Codable {
	let activityProtocol: String
	let repaidToken, repaidWithToken: ActivityTokenModel

	enum CodingKeys: String, CodingKey {
		case activityProtocol = "protocol"
		case repaidToken = "repaid_token"
		case repaidWithToken = "repaid_with"
	}
}

extension ActivityRepayModel {
	init(cdRepayActivityModel: CDRepayActivity) {
		self.txHash = cdRepayActivityModel.txHash
		self.type = cdRepayActivityModel.type
		self.detail = RepayActivityDetails(
			activityProtocol: cdRepayActivityModel.details.activityProtocol,
			repaidToken: ActivityTokenModel(
				amount: cdRepayActivityModel.details.repaid_token.amount,
				tokenID: cdRepayActivityModel.details.repaid_token.tokenId
			),
			repaidWithToken: ActivityTokenModel(
				amount: cdRepayActivityModel.details.repaid_with_token.amount,
				tokenID: cdRepayActivityModel.details.repaid_with_token.tokenId
			)
		)
		self.fromAddress = cdRepayActivityModel.fromAddress
		self.toAddress = cdRepayActivityModel.toAddress
		self.failed = nil
		self.blockNumber = nil
		self.blockTime = cdRepayActivityModel.blockTime
		self.gasUsed = cdRepayActivityModel.gasUsed
		self.gasPrice = cdRepayActivityModel.gasPrice
		self.prev_txHash = cdRepayActivityModel.prevTxHash
	}
}
