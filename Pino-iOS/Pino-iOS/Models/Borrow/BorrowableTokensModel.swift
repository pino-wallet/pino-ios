// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement

struct BorrowableTokenModel: Codable {
	let tokenID: String
	let tokenProtocol: ProtocolClass
	let apy: Int

	enum CodingKeys: String, CodingKey {
		case tokenID = "token_id"
		case tokenProtocol = "protocol"
		case apy
	}
}

// MARK: - ProtocolClass

struct ProtocolClass: Codable {
	let name, logo: String
}

typealias BorrowableTokensModel = [BorrowableTokenModel]
