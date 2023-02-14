//
//  EditAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import UIKit

class EditAccountViewController: UIViewController {
	// MARK: Private Properties

	private let walletVM: WalletsViewModel
	private let selectedWallet: WalletInfoViewModel

	// MARK: Initializers

	init(walletVM: WalletsViewModel, selectedWallet: WalletInfoViewModel) {
		self.walletVM = walletVM
		self.selectedWallet = selectedWallet
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
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = UIView()
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Edit account")
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(dismissPage)
		)
		let textAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.white,
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldBody!,
		]
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
	}

	@objc
	private func dismissPage() {
		dismiss(animated: true)
	}
}
