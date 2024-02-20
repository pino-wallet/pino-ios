// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityApproveModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: ApproveActivityDetail
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

// MARK: - Detail

struct ApproveActivityDetail: Codable {
	let amount, owner, spender, tokenID: String

	enum CodingKeys: String, CodingKey {
		case amount
		case owner
		case spender
		case tokenID = "token_id"
	}
}

extension ActivityApproveModel {
	init(cdApproveActivityModel: CDApproveActivity) {
		self.txHash = cdApproveActivityModel.txHash
		self.type = cdApproveActivityModel.type
		self.detail = ApproveActivityDetail(
			amount: cdApproveActivityModel.details.amount,
			owner: cdApproveActivityModel.details.owner,
			spender: cdApproveActivityModel.details.spender,
			tokenID: cdApproveActivityModel.details.tokenID
		)
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
