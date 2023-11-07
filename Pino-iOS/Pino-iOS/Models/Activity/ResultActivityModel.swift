// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement

enum ResultActivityModel: Decodable, Encodable {
	// MARK: - Cases

	case swap(ActivityModelProtocol)
	case transfer(ActivityModelProtocol)
	case transfer_from(ActivityModelProtocol)
    case borrow(ActivityBorrowModel)
    case collateral(ActivityCollateralModel)
    case repay(ActivityRepayModel)
    case withdraw(ActivityWithdrawModel)
    case invest(ActivityInvestModel)
	case unknown(UnknownActivityModel?)

	// MARK: - Coding keys

	enum CodingKeys: String, CodingKey {
		case type
	}

	// MARK: - Initializers

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)

		switch ActivityType(rawValue: type) {
		case .transfer_from:
			let transferActivity = try ActivityTransferModel(from: decoder)
			self = .transfer(transferActivity)
		case .swap:
			let swapActivity = try ActivitySwapModel(from: decoder)
			self = .swap(swapActivity)
		case .transfer:
			let transferActivity = try ActivityTransferModel(from: decoder)
			self = .transfer(transferActivity)
        case .create_investment, .create_withdraw_investment:
        case .decrease_investment:
        case .increase_investment:
        case .withdraw_investment:
        case .borrow:
        case .repay:
        case .repay_behalf:
        case .increase_collateral:
        case .decrease_collateral:
        case .create_collateral:
        case .remove_collateral:
//		default:
//			self = .unknown(nil)
		}
	}

	// MARK: - Methods

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		switch self {
		case let .swap(swapActivity):
			try container.encode(ActivityType.swap.rawValue, forKey: .type)
			try swapActivity.encode(to: encoder)
		case let .transfer(transferActivity):
			try container.encode(ActivityType.transfer.rawValue, forKey: .type)
			try transferActivity.encode(to: encoder)
		case let .transfer_from(transferActivity):
			try container.encode(ActivityType.transfer_from.rawValue, forKey: .type)
			try transferActivity.encode(to: encoder)
        case .borrow(_):
            <#code#>
        case .collateral(_):
            <#code#>
        case .repay(_):
            <#code#>
        case .withdraw(_):
            <#code#>
        case .invest(_):
            <#code#>
		case let .unknown(nilDetails):
			try nilDetails.encode(to: encoder)
        }
	}
}

struct UnknownActivityModel: Codable {}

typealias ActivitiesModel = [ResultActivityModel]
