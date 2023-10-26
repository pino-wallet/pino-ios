// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paraSwapPriceResponseModel = try? JSONDecoder().decode(ParaSwapPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ParaSwapPriceResponseModel

struct ParaSwapPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	public let priceRoute: Data

	// MARK: - Public Properties

	public var provider: SwapProvider {
		.paraswap
	}

	public let srcAmount: String
	public let destAmount: String

	enum CodingKeys: CodingKey {
		case priceRoute
		case srcAmount
		case destAmount
	}

	// Silencing compiler warning
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let priceRouteString = try container.decode(String.self, forKey: .priceRoute)
		guard let priceRouteData = Data(base64Encoded: priceRouteString) else {
			throw DecodingError.dataCorruptedError(
				forKey: .priceRoute,
				in: container,
				debugDescription: "priceRoute is not valid base64"
			)
		}
		self.priceRoute = priceRouteData
		self.srcAmount = try container.decode(String.self, forKey: .srcAmount)
		self.destAmount = try container.decode(String.self, forKey: .destAmount)
	}

	internal init(priceRoute: Data) {
		self.priceRoute = priceRoute
		let dictionary = try! JSONSerialization.jsonObject(with: priceRoute, options: []) as! [String: Any]
		let priceRoute = dictionary["priceRoute"] as! [String: Any]
		self.srcAmount = priceRoute["srcAmount"] as! String
		self.destAmount = priceRoute["destAmount"] as! String
	}
}
