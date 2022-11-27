//
//  ImportWalletViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: 2, curreuntStep: 1)
		setupNavigationBackButton()
	}

	// MARK: Private Methods

	private func stupView() {
		let importSecretPhraseView = ImportSecretPhraseView {
			self.importWallet()
		}
		view = importSecretPhraseView
	}

	private func importWallet() {
		// Wallet should be verified here
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
