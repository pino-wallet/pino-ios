// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement

struct ActivitySwapModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var detail: SwapActivityDetails
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

struct SwapActivityDetails: Codable {
	let fromToken, toToken: ActivityTokenModel
	var activityProtocol: String

	enum CodingKeys: String, CodingKey {
		case fromToken = "token0"
		case toToken = "token1"
		case activityProtocol = "protocol"
	}
}

extension ActivitySwapModel {
	init(cdSwapActivityModel: CDSwapActivity) {
		self.txHash = cdSwapActivityModel.txHash
		self.type = cdSwapActivityModel.type
		self.detail = SwapActivityDetails(
			fromToken: ActivityTokenModel(
				amount: cdSwapActivityModel.details.from_token.amount,
				tokenID: cdSwapActivityModel.details.from_token.tokenId
			),
			toToken: ActivityTokenModel(
				amount: cdSwapActivityModel.details.to_token.amount,
				tokenID: cdSwapActivityModel.details.to_token.tokenId
			),
			activityProtocol: cdSwapActivityModel.details.activityProtool
		)
		self.fromAddress = cdSwapActivityModel.fromAddress
		self.toAddress = cdSwapActivityModel.toAddress
		switch ActivityStatus(rawValue: cdSwapActivityModel.status) {
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
		self.blockTime = cdSwapActivityModel.blockTime
		self.gasUsed = cdSwapActivityModel.gasUsed
		self.gasPrice = cdSwapActivityModel.gasPrice
		self.prev_txHash = cdSwapActivityModel.prevTxHash
	}
}
