//
//  AllDoneViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//

import Combine
import Foundation
import PromiseKit

class AllDoneViewModel {
	// MARK: Public Properties

	public let image = "pino_logo"
	public let title = "You’re all done!"
	public let description = "The world of DeFi awaits you."
	public let continueButtonTitle = "Get started"
	public let allDoneAnimationName = "AllDoneAnimation"

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
	private let mnemonics: String
	private let accActivationVM = AccountActivationViewModel()

	init(mnemonics: String) {
		self.mnemonics = mnemonics
	}

	// MARK: - Public Methods

	public func importSelectedAccounts(
		selectedAccounts: [ActiveAccountViewModel]
	) -> Promise<Void> {
		let coreDataManager = CoreDataManager()

		return firstly {
			createInitialWalletsInCoreData()
		}.then { [self] createdWallet in
			pinoWalletManager.createHDWalletWith(mnemonics: mnemonics, for: selectedAccounts).map { createdWallet }
		}.done { createdWallet in
			for account in selectedAccounts {
				coreDataManager.createWalletAccount(
					address: account.address,
					publicKey: account.publicKey,
					name: account.name,
					avatarIcon: account.profileImage,
					avatarColor: account.profileColor,
					wallet: createdWallet
				)
			}
			let createdAccounts = coreDataManager.getAllWalletAccounts()
			coreDataManager.updateSelectedWalletAccount(createdAccounts.first!)
		}
	}

	public func createWallet(mnemonics: String) -> Promise<Void> {
		Promise<Void> { seal in
			isNetConnected().filter { $0 }.sink { _ in } receiveValue: { [self] isConnected in
				firstly {
					pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				}.then { initialAccount in
					self.accActivationVM.activateNewAccountAddress(initialAccount).map { ($0, initialAccount) }
				}.then { activatedAccount, initialAccount in
					self.createInitialWalletsInCoreData().map { ($0, initialAccount) }
				}.done { createdWallet, initialAccount in
					self.createInitalAddressInCoreDataIn(wallet: createdWallet, account: initialAccount)
					seal.fulfill(())
				}.catch { error in
					seal.reject(error)
					self.coreDataManager.deleteAllWalletAccounts()
				}
			}.store(in: &cancellables)
		}
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

	private func createInitialWalletsInCoreData() -> Promise<Wallet> {
		Promise<Wallet> { seal in
			let coreDataManager = CoreDataManager()
			let hdWallet = coreDataManager.createWallet(type: .hdWallet, lastDrivedIndex: 0)
			coreDataManager.createWallet(type: .nonHDWallet)
			seal.fulfill(hdWallet)
		}
	}
}
