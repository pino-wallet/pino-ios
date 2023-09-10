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

    public let healthScoreTitle = "Health Score"
    public let healthScoreDescription = "This shows how safe your collateral is from liquidation."
    public let yourScoreText = "Your score"
    public let liquidationZoneDescription = "Liquidation (Health Score = 0): The protocol can sell your collateral to repay your debt."
    public let dangerZoneDescribtion = "Danger (0 < Health Score ≤ 10): You are near liquidation."
    public let safetyZoneDescribtion = "Safety (10 < Health Score < 100): Your position is secure."
    public let gotItButtonTitle = "Got it"
    public let startHealthScoreNumber = "0"
    public let endHealthScoreNumber = "100"

    // MARK: - Initializers
    init(healthScoreNumber: Double) {
        self.healthScoreNumber = healthScoreNumber
    }
}
