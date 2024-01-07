//
//  SyncWalletViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import UIKit

class SyncWalletViewController: UIViewController {
	// MARK: - Private Properties

	private var syncWalletVM: SyncWalletViewModel
	private var syncWalletView: SyncWalletView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {
		syncWalletView.animateLoading()
	}

	// MARK: - Initializers

	init(syncWalletVM: SyncWalletViewModel) {
		self.syncWalletVM = syncWalletVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		syncWalletView = SyncWalletView(syncWalletVM: syncWalletVM)

		view = syncWalletView
	}
}
