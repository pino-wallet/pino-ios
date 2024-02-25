// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivityBorrowModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: BorrowActivityDetails
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

struct BorrowActivityDetails: Codable {
	let activityProtocol: String
	let token: ActivityTokenModel

	enum CodingKeys: String, CodingKey {
		case activityProtocol = "protocol"
		case token
	}
}

extension ActivityBorrowModel {
	init(cdBorrowActivityModel: CDBorrowActivity) {
		self.txHash = cdBorrowActivityModel.txHash
		self.type = cdBorrowActivityModel.type
		self.detail = BorrowActivityDetails(
			activityProtocol: cdBorrowActivityModel.details.activityProtocol,
			token: ActivityTokenModel(
				amount: cdBorrowActivityModel.details.token.amount,
				tokenID: cdBorrowActivityModel.details.token.tokenId
			)
		)
		self.fromAddress = cdBorrowActivityModel.fromAddress
		self.toAddress = cdBorrowActivityModel.toAddress
        switch ActivityStatus(rawValue: cdBorrowActivityModel.status) {
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
		self.blockTime = cdBorrowActivityModel.blockTime
		self.gasUsed = cdBorrowActivityModel.gasUsed
		self.gasPrice = cdBorrowActivityModel.gasPrice
		self.prev_txHash = cdBorrowActivityModel.prevTxHash
	}
}
