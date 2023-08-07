//
//  SwapPriceResponseProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation

protocol SwapPriceResponseProtocol: Codable {
	var provider: SwapProviderViewModel.SwapProvider { get }
	var tokenAmount: String { get }
	var gasFee: String { get }
	var gasFeeInDollar: String { get }
}
