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
            throw DecodingError.dataCorruptedError(forKey: .priceRoute, in: container, debugDescription: "priceRoute is not valid base64")
        }
        priceRoute = priceRouteData
        srcAmount = try container.decode(String.self, forKey: .srcAmount)
        destAmount = try container.decode(String.self, forKey: .destAmount)
    }
   
    internal init(priceRoute: Data) {
        self.priceRoute = priceRoute
        let dictionary = try! JSONSerialization.jsonObject(with: priceRoute, options: []) as! [String: Any]
        print("Retrieved dictionary: \(dictionary)")
        let priceRoute = dictionary["priceRoute"] as! [String : Any]
        self.srcAmount = priceRoute["srcAmount"] as! String
        self.destAmount = priceRoute["destAmount"] as! String
    }
}

// MARK: - PriceRouteClass

struct PriceRouteClass: Codable {
	let blockNumber, network: Int
	let srcToken: String
	let srcDecimals: Int
	let srcAmount, destToken: String
	let destDecimals: Int
	let destAmount: String
	let bestRoute: [BestRoute]
	let gasCostUSD, gasCost, side, tokenTransferProxy: String
	let contractAddress, contractMethod: String
	let partnerFee: Int
	let srcUSD, destUSD, partner: String
	let maxImpactReached: Bool
	let hmac: String

	// MARK: - BestRoute

	struct BestRoute: Codable {
		let percent: Int
		let swaps: [Swap]
	}

	// MARK: - Swap

	struct Swap: Codable {
		let srcToken: String
		let srcDecimals: Int
		let destToken: String
		let destDecimals: Int
		let swapExchanges: [SwapExchange]
	}

	// MARK: - SwapExchange

	struct SwapExchange: Codable {
		let exchange, srcAmount, destAmount: String
		let percent: Int
		let poolAddresses: [String]
		let data: DataClass
	}

	// MARK: - DataClass

	struct DataClass: Codable {
		let router: String?
		let path: [String]?
		let factory, initCode: String?
		let feeFactor: Int?
		let pools: [Pool]?
		let gasUSD: String
	}

	// MARK: - Pool

	struct Pool: Codable {
		let address: String
		let fee: Int
		let direction: Bool
	}
}
