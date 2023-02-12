//
//  CoinInfoModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/22/23.
//

import Foundation

struct CoinInfoModel {
	// MARK: - public properties

	public var assetImage: String
	public var userAmount: String?
	public var coinAmount: String?
	public var name: String
	public var volatilityRate: String
	public var volatilityType: AssetVolatilityType?
	public var investAmount: String?
	public var collateralAmount: String?
	public var barrowAmount: String?
}
