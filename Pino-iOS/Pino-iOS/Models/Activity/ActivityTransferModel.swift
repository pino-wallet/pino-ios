// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityTransferModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: TransferActivityDetail
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

struct TransferActivityDetail: Codable {
	var amount: String
	var tokenID: String
	var from: String
	var to: String

	enum CodingKeys: String, CodingKey {
		case amount
		case tokenID = "token_id"
		case from, to
	}
}

extension ActivityTransferModel {
	init(cdTransferActivityModel: CDTransferActivity) {
		self.txHash = cdTransferActivityModel.txHash
		self.type = cdTransferActivityModel.type
		self.detail = TransferActivityDetail(
			amount: cdTransferActivityModel.details.amount,
			tokenID: cdTransferActivityModel.details.tokenID,
			from: cdTransferActivityModel.details.from,
			to: cdTransferActivityModel.details.to
		)
		self.fromAddress = cdTransferActivityModel.fromAddress
		self.toAddress = cdTransferActivityModel.toAddress
		switch ActivityStatus(rawValue: cdTransferActivityModel.status) {
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
		self.blockTime = cdTransferActivityModel.blockTime
		self.gasUsed = cdTransferActivityModel.gasUsed
		self.gasPrice = cdTransferActivityModel.gasPrice
		self.prev_txHash = cdTransferActivityModel.prevTxHash
	}
}
