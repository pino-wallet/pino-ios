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

	enum CodingKeys: String, CodingKey {
		case id
		case image
		case name
		case codeName = "code_name"
		case amount
		case amountInDollor = "amount_in_dollor"
		case volatilityInDollor = "volatility_in_dollor"
		case volatilityType = "volatility_type"
		case isSelected = "is_selected"
	}

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		isSelected.toggle()
	}
}

struct Assets: Codable {
	// MARK: Public Properties

	public let assetsList: [AssetModel]

	// MARK: Public Enums

	public enum CodingKeys: String, CodingKey {
		case assetsList = "data"
	}
}

struct Positions: Codable {
	// MARK: Public Properties

	public let positionsList: [AssetModel]

	// MARK: Public Enums

	public enum CodingKeys: String, CodingKey {
		case positionsList = "data"
	}
}
