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

	public func importSelectedAccounts(
		selectedAccounts: [ActiveAccountViewModel],
		completion: @escaping (WalletOperationError?) -> Void
	) {
		createInitialWalletsInCoreData { wallet in
			for account in selectedAccounts {
				do {
					coreDataManager.createWalletAccount(
						address: account.address,
						publicKey: account.publicKey,
						name: account.name,
						avatarIcon: account.profileImage,
						avatarColor: account.profileColor,
						wallet: wallet
					)
					try pinoWalletManager.createAccount(account: account)
					completion(nil)
				} catch {
					completion(WalletOperationError.unknow(error))
				}
			}
		}
	}

	public func createWallet(mnemonics: String, walletCreated: @escaping (WalletOperationError?) -> Void) {
		isNetConnected().sink { _ in } receiveValue: { [self] isConnected in
			if isConnected {
				let initalAccount = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				switch initalAccount {
				case let .success(account):
					let accActivationVM = AccountActivationViewModel()
					accActivationVM.activateNewAccountAddress(account.eip55Address) { [self] result in
						switch result {
						case .success:
							createInitialWalletsInCoreData { createdWallet in
								createInitalAddressInCoreDataIn(wallet: createdWallet, account: account)
								walletCreated(nil)
							}
						case let .failure(failure):
							walletCreated(.wallet(.accountActivationFailed(failure)))
						}
					}
				case let .failure(failure):
					walletCreated(.wallet(.accountActivationFailed(failure)))
				}
			} else {
				walletCreated(.wallet(.netwrokError))
			}
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func isNetConnected() -> AnyPublisher<Bool, Error> {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.eraseToAnyPublisher()
	}

	private func createInitalAddressInCoreDataIn(wallet: Wallet, account: Account) {
		let newAvatar = Avatar.randAvatar()

		coreDataManager.createWalletAccount(
			address: account.eip55Address,
			publicKey: account.publicKey.hex(),
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
