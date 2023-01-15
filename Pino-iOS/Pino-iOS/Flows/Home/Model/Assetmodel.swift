//
//  Assetmodel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import Foundation

public struct AssetModel: Codable {
	// MARK: - Public Properties

	public var image: String
	public var name: String
	public var codeName: String
	public var amount: String?
	public var amountInDollor: String?
	public var volatilityInDollor: String?
	public var volatilityType: AssetVolatilityType?
	public var isSelected: Bool

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		isSelected.toggle()
	}
}
