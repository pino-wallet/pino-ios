//
//  InvestmentBoardAssetProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Foundation

protocol AssetsBoardProtocol {
	var assetName: String { get }
	var assetImage: URL { get }
	var protocolImage: String { get }
}

extension AssetsBoardProtocol {
	var protocolImage: String {
		.emptyString
	}
}
