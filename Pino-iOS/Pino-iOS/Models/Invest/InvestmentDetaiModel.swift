//
//  InvestmentDetaiModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/12/23.
//

import Foundation

struct InvestmentDetailModel: Codable {
	// MARK: - Public Properties

	public let capital: String
	public let currentAmount: String
	public let details: String
	public let id: String
	public let investProtocol: String
	public let userID: String

	enum CodingKeys: String, CodingKey {
		case capital
		case currentAmount = "current_amount"
		case details
		case id
		case investProtocol = "protocol"
		case userID = "user_id"
	}
}
