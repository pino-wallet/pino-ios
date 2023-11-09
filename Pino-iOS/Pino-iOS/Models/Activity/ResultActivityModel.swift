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
	//    case collateral(ActivityCollateralModel)
	case repay(ActivityRepayModel)
	case withdraw(ActivityWithdrawModel)
	//    case invest(ActivityInvestModel)
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
		//        case .create_investment, .create_withdraw_investment, .increase_investment:
		//            let investActivity = try ActivityInvestModel(from: decoder)
		//            self = .invest(investActivity)
		//        case .withdraw_investment, .decrease_investment:
		//            let withdrawActivity = try ActivityWithdrawModel(from: decoder)
		//            self = .withdraw(withdrawActivity)
		case .borrow:
			let borrowActivity = try ActivityBorrowModel(from: decoder)
			self = .borrow(borrowActivity)
		case .repay, .repay_behalf:
			let repayActivity = try ActivityRepayModel(from: decoder)
			self = .repay(repayActivity)
		//        case .increase_collateral, .decrease_collateral, .create_collateral, .remove_collateral:
		//            let collateralActivity = try ActivityCollateralModel(from: decoder)
		//            self = .collateral(collateralActivity)
		default:
			self = .unknown(nil)
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
		case let .borrow(borrowActivity):
			try container.encode(ActivityType.borrow.rawValue, forKey: .type)
			try borrowActivity.encode(to: encoder)
//		        case let .collateral(collateralActivity):
//		            try container.encode(ActivityType.create_collateral.rawValue, forKey: .type)
//		            try collateralActivity.encode(to: encoder)
		case let .repay(repayActivity):
			try container.encode(ActivityType.repay.rawValue, forKey: .type)
			try repayActivity.encode(to: encoder)
		case let .withdraw(withdrawActivity):
			try container.encode(ActivityType.withdraw_investment.rawValue, forKey: .type)
			try withdrawActivity.encode(to: encoder)
		//        case let .invest(investActivity):
		//            try container.encode(ActivityType.create_investment.rawValue, forKey: .type)
		//            try investActivity.encode(to: encoder)
		case let .unknown(nilDetails):
			try nilDetails.encode(to: encoder)
		}
	}
}

struct UnknownActivityModel: Codable {}

typealias ActivitiesModel = [ResultActivityModel]
