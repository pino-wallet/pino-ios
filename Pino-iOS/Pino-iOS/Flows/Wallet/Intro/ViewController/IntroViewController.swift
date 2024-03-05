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
				self.openCreateWalletPage()
			},
			importWallet: {
				self.openImportWalletPage()
			}
		)
		navigationController?.navigationBar.prefersLargeTitles = false
		view = introView
	}

	private func openCreateWalletPage() {
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
				self.openCreateWalletPage()
			}
		}
	}

	private func openImportWalletPage() {
		if let userCanTestBeta = introVM.userCanTestBeta {
			if userCanTestBeta {
				let importSecretPhrasePage = ImportSecretPhraseViewController()
				navigationController?.pushViewController(importSecretPhrasePage, animated: true)
			} else {
				openInviteCodePage()
			}
		} else {
			introView.showImportWalletLoading()
			introVM.checkBetaAvailibity { isValid in
				self.introView.resetButtonsStatus()
				self.openImportWalletPage()
			}
		}
	}

	private func openInviteCodePage() {
		let inviteCodePage = EnterInviteCodeViewController()
		present(inviteCodePage, animated: true)
	}
}
