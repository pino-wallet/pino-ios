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
		introView.showCreateWalletLoading()
		introVM.checkBetaAvailibity { isValid in
			self.introView.resetButtonsStatus()
			if isValid {
                self.presentCreateWalletPage()
			} else {
				self.openInviteCodeFromCreateWalletPage()
			}
		}
	}

	private func openImportWalletPage() {
		introView.showImportWalletLoading()
		introVM.checkBetaAvailibity { isValid in
			self.introView.resetButtonsStatus()
			if isValid {
                self.presentImportWalletPage()
			} else {
				self.openInviteCodeFromImportWalletPage()
			}
		}
	}
    
    private func presentCreateWalletPage() {
        let showSecretPhrasePage = ShowSecretPhraseViewController()
        self.navigationController?.pushViewController(showSecretPhrasePage, animated: true)
    }
    
    private func presentImportWalletPage() {
        let importSecretPhrasePage = ImportSecretPhraseViewController()
        self.navigationController?.pushViewController(importSecretPhrasePage, animated: true)
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
