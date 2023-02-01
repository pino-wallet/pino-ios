//
//  Assetmodel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import Foundation

public struct AssetModel: Codable {
	// MARK: - Public Properties

	public var id: String
	public var image: String
	public var name: String
	public var codeName: String
	public var amount: String
	public var amountInDollor: String
	public var volatilityInDollor: String
	public var volatilityType: String
	public var isSelected: Bool

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		isSelected.toggle()
	}
}

struct Assets: Codable {
	// MARK: Public Properties

	public let assets: [AssetModel]

	// MARK: Public Enums

	public enum CodingKeys: String, CodingKey {
		case assets = "data"
	}
}
