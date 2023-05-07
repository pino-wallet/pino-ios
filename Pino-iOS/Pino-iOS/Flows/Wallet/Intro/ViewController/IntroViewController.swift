//
//  IntroViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/7/22.
//

import UIKit

class IntroViewController: UIViewController {
	// MARK: Private Properties

	private let introVM = IntroViewModel()

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	// MARK: Private Methods

	private func setupView() {
		let introView = IntroView(
			introVM: introVM,
			createWallet: {
				self.goToCreateWalletPage()
			},
			importWallet: {
				self.goToImportWalletPage()
			}
		)
		view = introView
	}

	private func goToCreateWalletPage() {
		let showSecretPhrasePage = ShowSecretPhraseViewController()
		navigationController?.pushViewController(showSecretPhrasePage, animated: true)
	}

	private func goToImportWalletPage() {
		let importSecretPhrasePage = ImportSecretPhraseViewController()
        importSecretPhrasePage.isNewWallet = true
		navigationController?.pushViewController(importSecretPhrasePage, animated: true)
	}
}
