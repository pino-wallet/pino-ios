//
//  VerifySecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class VerifySecretPhraseViewController: UIViewController {
	// MARK: Public Properties

	public var secretPhraseVM: VerifySecretPhraseViewModel!
	public var isNewWallet = false

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		if isNewWallet {
			setupPrimaryColorNavigationBar()
			setNavigationTitle(secretPhraseVM.pageTitle)
		} else {
			setSteperView(stepsCount: 3, curreuntStep: 2)
		}
	}

	// MARK: Private Methods

	private func createWallet(_ sortedPhrase: [String]) {
		if isNewWallet {
			UserDefaults.standard.set(true, forKey: "isLogin")
			let tabBarVC = TabBarViewController()
			tabBarVC.modalPresentationStyle = .fullScreen
			present(tabBarVC, animated: true)
		} else {
			// Wallet should be created here
			// Go to create passcode page
			let createPasscodeViewController = CreatePasscodeViewController()
			createPasscodeViewController.pageSteps = 3
			navigationController?.pushViewController(createPasscodeViewController, animated: true)
		}
	}
}

extension VerifySecretPhraseViewController {
	// MARK: Private UI Methods

	private func setupView() {
		let verifySecretPhraseView = VerifySecretPhraseView(secretPhraseVM: secretPhraseVM) { sortedPhrase in
			self.createWallet(sortedPhrase)
		}
		view = verifySecretPhraseView
	}
}
