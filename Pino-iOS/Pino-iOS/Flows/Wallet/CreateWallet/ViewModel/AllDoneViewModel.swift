//
//  AllDoneViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//

import Foundation
import Combine

struct AllDoneViewModel {
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
    private var accountingAPIClient = AccountingAPIClient()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    mutating func createWallet(mnemonics: String, walletCreated: @escaping (String)->() ) {
        #warning("should have a fallback plan in case request failed")
        let wallet = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
        switch wallet {
        case .success(_):
            accountingAPIClient.activateAccountWith(address: pinoWalletManager.currentAccount.eip55Address)
                .sink(receiveCompletion: { completed in
                    switch completed {
                    case .finished:
                        print("Wallet balance received successfully")
                    case let .failure(error):
                        print(error)
                    }
                }) { activatedAccount in
                    walletCreated(activatedAccount.id)
                }.store(in: &cancellables)
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }

}
