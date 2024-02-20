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
    txHash = cdCollateralActivityModel.txHash
    type = cdCollateralActivityModel.type
    detail = CollateralActivityDetails(
        activityProtocol: cdCollateralActivityModel.details.activityProtocol,
        tokens: cdCollateralActivityModel.details.tokens.compactMap {
            ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
        }
    )
    fromAddress = cdCollateralActivityModel.fromAddress
    toAddress = cdCollateralActivityModel.toAddress
    failed = nil
    blockNumber = nil
    blockTime = cdCollateralActivityModel.blockTime
    gasUsed = cdCollateralActivityModel.gasUsed
    gasPrice = cdCollateralActivityModel.gasPrice
    prev_txHash = cdCollateralActivityModel.prevTxHash
    }
}
