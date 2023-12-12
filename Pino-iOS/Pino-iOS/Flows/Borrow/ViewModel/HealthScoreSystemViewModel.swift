//
//  HealthScoreSystemViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/9/23.
//
import Foundation

struct HealthScoreSystemViewModel {
	// MARK: - Public Properties

	public var healthScoreNumber: Double
	public var formattedHealthScore: String {
		if healthScoreNumber >= 1 && healthScoreNumber < 10 {
			return String(format: "%.1f", healthScoreNumber)
		} else if healthScoreNumber >= 10 {
			return String(format: "%.f", floor(healthScoreNumber))
		} else {
			return healthScoreNumber.description
		}
	}

	public let healthScoreTitle = "Health Score"
	public let healthScoreDescription = "This shows how safe your collateral is from liquidation."
	public let yourScoreText = "Your score"
	public let liquidationZoneDescription =
		"Liquidation [0]"
	public let dangerZoneDescribtion = "Danger [0- 10]"
	public let safetyZoneDescribtion = "Safety [10 - 100]"
	public let gotItButtonTitle = "Got it"
	public let startHealthScoreNumber = "0"
	public let endHealthScoreNumber = "100"

	// MARK: - Initializers

	init(healthScoreNumber: Double) {
		self.healthScoreNumber = healthScoreNumber
	}
}
