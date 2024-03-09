//
//  SyncWalletViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import UIKit

class SyncWalletViewController: UIViewController {
	// MARK: - Private Properties

	private var syncWalletVM = SyncWalletViewModel()
	private var syncWalletView: SyncWalletView!
    private var selectedAccounts: [ActiveAccountViewModel]
    private var mnemonics: String

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {
		syncWalletView.animateLoading()
		if isBeingPresented || isMovingToParent {
			clearNavbar()
		}
	}

	// MARK: - Initializers

    init(selectedAccounts: [ActiveAccountViewModel], mnemonics: String) {
        self.selectedAccounts = selectedAccounts
        self.mnemonics = mnemonics
        super.init(nibName: nil, bundle: nil)
    }

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		syncWalletView = SyncWalletView(syncWalletVM: syncWalletVM, presentTutorialPage: {
			self.presentTutorialPage()
        }, presentAllDonePage: {
            self.presentAllDonePage()
        })

		view = syncWalletView
	}

	private func presentTutorialPage() {
		let tutorialPage = TutorialViewController {
			self.dismiss(animated: true)
		}
		tutorialPage.modalPresentationStyle = .overFullScreen
		present(tutorialPage, animated: true)
	}
    
    private func presentAllDonePage() {
        let allDoneVC = AllDoneViewController(
            selectedAccounts: selectedAccounts,
            mnemonics: mnemonics
        )
        navigationController?.pushViewController(allDoneVC, animated: true)
    }
}
