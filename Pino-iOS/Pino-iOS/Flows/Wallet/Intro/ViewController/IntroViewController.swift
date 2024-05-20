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
				self.presentCreateWalletPage()
			},
			importWallet: {
				self.presentImportWalletPage()
			}
		)
		navigationController?.navigationBar.prefersLargeTitles = false
		view = introView
	}

	private func presentCreateWalletPage() {
		let showSecretPhrasePage = ShowSecretPhraseViewController()
		navigationController?.pushViewController(showSecretPhrasePage, animated: true)
	}

	private func presentImportWalletPage() {
		let importSecretPhrasePage = ImportSecretPhraseViewController()
		navigationController?.pushViewController(importSecretPhrasePage, animated: true)
	}

	private func openInviteCodeFromCreateWalletPage() {
		let inviteCodePage = EnterInviteCodeViewController(presentNextPageClosure: {
			self.presentCreateWalletPage()
		})
		present(inviteCodePage, animated: true)
	}

	private func openInviteCodeFromImportWalletPage() {
		let inviteCodePage = EnterInviteCodeViewController(presentNextPageClosure: {
			self.presentImportWalletPage()
		})
		present(inviteCodePage, animated: true)
	}
}
