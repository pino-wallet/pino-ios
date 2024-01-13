//
//  WalletBalanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

class WalletBalanceViewModel: SecurityModeProtocol {
	// MARK: - Public Properties

	public var balanceModel: WalletBalanceModel!

	public var securityMode = false

	public var balance = GlobalZeroAmounts.tokenAmount.zeroAmount

	public var volatilityPercentage: String {
		getFormattedVolatilityPercentage()
	}

	public var volatilityInDollor: String {
		getFormattedVolatilityInDollor()
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: balanceModel.volatilityNumber)
	}

	// MARK: - Initializers

	init(balanceModel: WalletBalanceModel) {
		self.balanceModel = balanceModel
		self.balance = getFormattedBalance()
	}

	// MARK: - Public Methods

	public func switchSecurityMode(_ isOn: Bool) {
		if isOn {
			securityMode = true
			balance = securityText
		} else {
			securityMode = false
			balance = getFormattedBalance()
		}
	}

	// MARK: - Private Methods

	private func getFormattedBalance() -> String {
		balanceModel.balance.priceFormat
	}

	private func getFormattedVolatilityPercentage() -> String {
		switch volatilityType {
		case .profit:
			return "+\(balanceModel.volatilityPercentage)%"
		case .loss:
			return "\(balanceModel.volatilityPercentage)%"
		case .none:
			return "\(balanceModel.volatilityPercentage)%"
		}
	}

	private func getFormattedVolatilityInDollor() -> String {
		switch volatilityType {
		case .profit:
			return "+\(balanceModel.volatilityInDollor.priceFormat)"
		case .loss:
			return "-\(balanceModel.volatilityInDollor.priceFormat)"
		case .none:
			return balanceModel.volatilityInDollor.priceFormat
		}
	}
}
