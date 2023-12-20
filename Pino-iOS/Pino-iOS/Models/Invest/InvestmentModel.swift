//
//  InvestmentModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/12/23.
//

import Foundation

struct InvestmentModel: Codable {
	// MARK: - Public Properties

	public let capital: String
	public let currentWorth: String
	public let id: String
	public let lastDayWorth: String
	public let listingID: String
	public let protocolName: String
	public let userID: String
	public let tokens: [InvestToken]

	enum CodingKeys: String, CodingKey {
		case capital
		case currentWorth = "current_worth"
		case id
		case lastDayWorth = "last_day_worth"
		case listingID = "listing_id"
		case protocolName = "protocol"
		case userID = "user_id"
		case tokens
	}

	struct InvestToken: Codable {
		// MARK: - Public Properties

		public let amount: String
		public let idx: Int?
		public let investmentID: String
		public let tokenID: String

		enum CodingKeys: String, CodingKey {
			case amount
			case idx
			case investmentID = "investment_id"
			case tokenID = "token_id"
		}
	}
}
