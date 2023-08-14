// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oneInchPriceResponseModel = try? JSONDecoder().decode(OneInchPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - OneInchPriceResponseModel

struct OneInchPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	private let toAmount: String
	private let gas: Int

	// MARK: - Public Properties

	public var provider: SwapProvider {
		.oneInch
	}

	public var srcAmount: String {
		.emptyString
	}

	public var destAmount: String {
		toAmount
	}

	public var gasFee: String {
		"\(gas)"
	}
}
