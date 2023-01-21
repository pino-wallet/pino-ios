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
		self.balance = "$\(balanceModel.balance)"
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
		"$\(balanceModel.balance)"
	}

	private func getFormattedVolatilityPercentage() -> String {
		switch volatilityType {
		case .profit:
			return "+\(balanceModel.volatilityPercentage)%"
		case .loss:
			return "-\(balanceModel.volatilityPercentage)%"
		case .none:
			return "\(balanceModel.volatilityPercentage)%"
		}
	}

	private func getFormattedVolatilityInDollor() -> String {
		switch volatilityType {
		case .profit:
			return "+$\(balanceModel.volatilityInDollor)"
		case .loss:
			return "-$\(balanceModel.volatilityInDollor)"
		case .none:
			return "$\(balanceModel.volatilityInDollor)"
		}
	}
}
