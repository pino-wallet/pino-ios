//
//  CustomAssetModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/13/23.
//

import BigInt

struct CustomAssetModel {
	public let id: String
	public let name: String
	public let symbol: String
	public let balance: BigUInt?
	public let decimal: BigUInt
}
