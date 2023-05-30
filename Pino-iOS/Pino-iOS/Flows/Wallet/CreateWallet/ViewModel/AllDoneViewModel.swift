//
//  AllDoneViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//

import Combine
import Foundation

class AllDoneViewModel {
	// MARK: Public Properties

	public let image = "pino_logo"
	public let title = "You’re all done!"
	public let description = "A one line description should be here"
	public let continueButtonTitle = "Get started"

	public var agreementAttributedTest: NSMutableAttributedString {
		#warning("This must be replaced with pino urls")
		let temporaryTermOfServiceURL = URL(string: "http://google.com/")!
		let temporaryPrivacyPolicyURL = URL(string: "http://google.com/")!
		let attributedText = NSMutableAttributedString(string: "I agree to the Term of use and Privacy policy")
		let termOfUseRange = (attributedText.string as NSString).range(of: "Term of use")
		let privacyPolicyRange = (attributedText.string as NSString).range(of: "Privacy policy")
		attributedText.setAttributes([.link: temporaryTermOfServiceURL], range: termOfUseRange)
		attributedText.setAttributes([.link: temporaryPrivacyPolicyURL], range: privacyPolicyRange)
		return attributedText
	}

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private let coreDataManager = CoreDataManager()
	private let internetConnectivity = InternetConnectivity()
	private var cancellables = Set<AnyCancellable>()
	private var accountingAPIClient = AccountingAPIClient()

	// MARK: - Public Methods

	public func createWallet(mnemonics: String, walletCreated: @escaping (WalletOperationError?) -> Void) {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in } receiveValue: { [self] isConnected in
			if isConnected {
				let initalAccount = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				switch initalAccount {
				case let .success(account):
					accountingAPIClient.activateAccountWith(address: account.eip55Address)
						.retry(3)
						.sink(receiveCompletion: { [self] completed in
							switch completed {
							case .finished:
								walletCreated(nil)
								cancellables.forEach { $0.cancel() }
							case let .failure(error):
								walletCreated(.wallet(.accountActivationFailed(error)))
							}
						}) { [self] activatedAccount in
							createInitialWalletsInCoreData { createdWallet in
								createInitalAddressInCoreDataIn(wallet: createdWallet, account: account)
							}
							walletCreated(nil)
						}.store(in: &cancellables)
				case let .failure(failure):
					walletCreated(failure)
				}
			} else {
				walletCreated(.wallet(.netwrokError))
			}
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func createInitalAddressInCoreDataIn(wallet: Wallet, account: Account) {
		let newAvatar = Avatar.randAvatar()

		coreDataManager.createWalletAccount(
			address: account.eip55Address,
			publicKey: account.publicKey,
			name: newAvatar.name,
			avatarIcon: newAvatar.rawValue,
			avatarColor: newAvatar.rawValue,
			wallet: wallet
		)
	}

	private func createInitialWalletsInCoreData(completion: (Wallet) -> Void) {
		let coreDataManager = CoreDataManager()
		let hdWallet = coreDataManager.createWallet(type: .hdWallet, lastDrivedIndex: 0)
		coreDataManager.createWallet(type: .nonHDWallet)
		completion(hdWallet)
	}
}
