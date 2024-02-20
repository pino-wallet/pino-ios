// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityCollateralModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: CollateralActivityDetails
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

struct CollateralActivityDetails: Codable {
	let activityProtocol: String
	let tokens: [ActivityTokenModel]

	enum CodingKeys: String, CodingKey {
		case activityProtocol = "protocol"
		case tokens = "tokens"
	}
}

extension ActivityCollateralModel {
	init(cdCollateralActivityModel: CDCollateralActivity) {
		self.txHash = cdCollateralActivityModel.txHash
		self.type = cdCollateralActivityModel.type
		self.detail = CollateralActivityDetails(
			activityProtocol: cdCollateralActivityModel.details.activityProtocol,
			tokens: cdCollateralActivityModel.details.tokens.compactMap {
				ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
			}
		)
		self.fromAddress = cdCollateralActivityModel.fromAddress
		self.toAddress = cdCollateralActivityModel.toAddress
		self.failed = nil
		self.blockNumber = nil
		self.blockTime = cdCollateralActivityModel.blockTime
		self.gasUsed = cdCollateralActivityModel.gasUsed
		self.gasPrice = cdCollateralActivityModel.gasPrice
		self.prev_txHash = cdCollateralActivityModel.prevTxHash
	}
}
