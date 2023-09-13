//
//  ImportAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsViewController: UIViewController {
	// MARK: - PublicProperties

	public var importAccountsView: ImportAccountsView!
	public var importAccountsVM = ImportAccountsViewModel()

	// MARK: - Initializers

	init(walletMnemonics: String) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setSteperView(stepsCount: 3, curreuntStep: 2)
	}

	// MARK: - Private Methods

	private func setupView() {
		importAccountsView = ImportAccountsView(accountsVM: importAccountsVM, importButtonDidTap: {
			self.openPasscodePage()
		})
		view = importAccountsView
	}

	private func openPasscodePage() {
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 3
		createPasscodeViewController.walletMnemonics = ""
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
