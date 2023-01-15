//
//  WalletBalanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

struct WalletBalanceViewModel: SecurityModeProtocol {
	// MARK: - Public Properties

	public var balanceModel: WalletBalanceModel!
	public let showBalanceButtonTitle = "Show balance"
	public let showBalanceButtonImage = "eye"
	public var securityMode = false

	public var balance: String

	public var volatilityPercentage: String {
		getFormattedVolatilityPercentage()
	}

	public var volatilityInDollor: String {
		getFormattedVolatilityInDollor()
	}

	public var volatilityType: AssetVolatilityType {
		if let volatilityType = balanceModel.volatilityType {
			return volatilityType
		} else {
			return .none
		}
	}

	// MARK: - Initializers

	init(balanceModel: WalletBalanceModel) {
		self.balanceModel = balanceModel
		let balance = balanceModel.balance ?? "0.0"
		self.balance = "$\(balance)"
	}

	// MARK: - Public Methods

	public mutating func enableSecurityMode() {
		securityMode = true
		balance = securityText
	}

	public mutating func disableSecurityMode() {
		securityMode = false
		balance = getFormattedBalance()
	}

	// MARK: - Private Methods

	private func getFormattedBalance() -> String {
		let balance = balanceModel.balance ?? "0.0"
		return "$\(balance)"
	}

	private func getFormattedVolatilityPercentage() -> String {
		if let volatility = balanceModel.volatilityPercentage {
			switch volatilityType {
			case .profit:
				return "+\(volatility)%"
			case .loss:
				return "-\(volatility)%"
			case .none:
				return "\(volatility)%"
			}
		} else {
			return "0.0%"
		}
	}

	private func getFormattedVolatilityInDollor() -> String {
		if let volatility = balanceModel.volatilityInDollor {
			switch volatilityType {
			case .profit:
				return "+$\(volatility)"
			case .loss:
				return "-$\(volatility)"
			case .none:
				return "$\(volatility)"
			}
		} else {
			return "$0.0"
		}
	}
}
