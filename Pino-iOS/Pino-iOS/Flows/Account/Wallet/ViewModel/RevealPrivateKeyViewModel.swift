//
//  RevealPrivateKeyViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

struct RevealPrivateKeyViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Do not share your private key"
	public let pageDescription = "If someone has your private key, they will have full control of your wallet."
	public let revealTitle = "Tap to reveal private key"
	public let revealDescription = "Ensure no one sees your screen and tap here"
	public let copyButtonTitle = "Copy to clipboard"
	public let copyButtonImage = "square.on.square"
	public let screenshotAlertTitle = "Warning"
	public let screenshotAlertMessage = "It isn't safe to take a screenshot of your private key!"
	public let mockPrivateKey = String(repeating: "*", count: 90)
	public var selectedAccount: AccountInfoViewModel

	// MARK: - Private Properties

	public func privateKey() throws -> String {
		let pinoWalletManager = PinoWalletManager()
		return try pinoWalletManager.exportPrivateKeyFor(account: selectedAccount.walletAccountInfoModel).string
	}
}
