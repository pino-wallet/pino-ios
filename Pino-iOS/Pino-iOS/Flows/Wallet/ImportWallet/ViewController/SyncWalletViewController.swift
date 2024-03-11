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
	private var okBtnTappedCompletion: (() -> Void)?

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			clearNavbar()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		syncWalletView.animateLoading()
	}

	// MARK: - Initializers

	init(selectedAccounts: [ActiveAccountViewModel], mnemonics: String) {
		self.selectedAccounts = selectedAccounts
		self.mnemonics = mnemonics
		super.init(nibName: nil, bundle: nil)
	}

	convenience init(okBtnTappedCompletion: @escaping () -> Void) {
		self.init(selectedAccounts: [], mnemonics: .emptyString)
		self.okBtnTappedCompletion = okBtnTappedCompletion
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
		if let okBtnTappedCompletion {
			okBtnTappedCompletion()
			dismiss(animated: true)
		} else {
			let allDoneVC = AllDoneViewController(
				selectedAccounts: selectedAccounts,
				mnemonics: mnemonics
			)
			navigationController?.pushViewController(allDoneVC, animated: true)
		}
	}
}
