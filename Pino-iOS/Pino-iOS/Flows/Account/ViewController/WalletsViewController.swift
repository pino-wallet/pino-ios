//
//  WalletsViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import UIKit

class WalletsViewController: UIViewController {
	// MARK: Private Properties

	private let walletVM: WalletsViewModel

	// MARK: Initializers

	init(walletVM: WalletsViewModel) {
		self.walletVM = walletVM
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
		view = WalletsCollectionView(walletsVM: walletVM, walletSelected: { selectedWallet in

		})
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Wallets")
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "plus"),
			style: .plain,
			target: self,
			action: #selector(dismissProfile)
		)
	}

	@objc
	private func dismissProfile() {
		dismiss(animated: true)
	}
}
