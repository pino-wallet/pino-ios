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
	private var okBtnDidTap: (() -> Void)?

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
		if isBeingPresented || isMovingToParent {
			syncWalletView.animateLoading()
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		.darkContent
	}

	// MARK: - Initializers

	init(selectedAccounts: [ActiveAccountViewModel], mnemonics: String) {
		self.selectedAccounts = selectedAccounts
		self.mnemonics = mnemonics
		super.init(nibName: nil, bundle: nil)
	}

	convenience init(okBtnDidTap: @escaping () -> Void) {
		self.init(selectedAccounts: [], mnemonics: .emptyString)
		self.okBtnDidTap = okBtnDidTap
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		syncWalletView = SyncWalletView(syncWalletVM: syncWalletVM, presentTutorialPage: {
			self.presentTutorialPage()
		}, presentAllDonePage: { [self] in
			syncWalletView.clearAnimationCache()
			if let okBtnDidTap {
				okBtnDidTap()
				dismiss(animated: true)
			} else {
				presentAllDonePage()
			}
		})

		view = syncWalletView
	}

	private func presentTutorialPage() {
		let tutorialPage = TutorialViewController {
			self.dismiss(animated: true)
			self.syncWalletView.resumeAnimation()
		}
		tutorialPage.modalPresentationStyle = .fullScreen
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
