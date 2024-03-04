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
	private var introView: IntroView!

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		introVM.checkBetaAvailibity()
	}

	override func loadView() {
		setupView()
	}

	// MARK: Private Methods

	private func setupView() {
		introView = IntroView(
			introVM: introVM,
			createWallet: {
				self.goToCreateWalletPage()
			},
			importWallet: {
				self.goToImportWalletPage()
			}
		)
		navigationController?.navigationBar.prefersLargeTitles = false
		view = introView
	}

	private func goToCreateWalletPage() {
		if let userCanTestBeta = introVM.userCanTestBeta {
			if userCanTestBeta {
				let showSecretPhrasePage = ShowSecretPhraseViewController()
				navigationController?.pushViewController(showSecretPhrasePage, animated: true)
			} else {
				openInviteCodePage()
			}
		} else {
			introView.showCreateWalletLoading()
			introVM.checkBetaAvailibity { isValid in
				self.introView.resetButtonsStatus()
				self.goToImportWalletPage()
			}
		}
	}

	private func goToImportWalletPage() {
		if let userCanTestBeta = introVM.userCanTestBeta {
			if userCanTestBeta {
				let importSecretPhrasePage = ImportSecretPhraseViewController()
				importSecretPhrasePage.isNewWallet = true
				navigationController?.pushViewController(importSecretPhrasePage, animated: true)
			} else {
				openInviteCodePage()
			}
		} else {
			introView.showImportWalletLoading()
			introVM.checkBetaAvailibity { isValid in
				self.introView.resetButtonsStatus()
				self.goToImportWalletPage()
			}
		}
	}

	private func openInviteCodePage() {
		let inviteCodePage = EnterInviteCodeViewController()
		present(inviteCodePage, animated: true)
	}
}
