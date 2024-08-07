// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct ParaswapSwapResponseModel: Codable {
	public let from, to, value, data: String
	public let gasPrice: String
	public let chainID: Int

	enum CodingKeys: String, CodingKey {
		case from
		case to
		case value
		case data
		case gasPrice
		case chainID = "chainId"
	}
}

extension ParaswapSwapResponseModel: SwapCoinResponseProtocol {}
