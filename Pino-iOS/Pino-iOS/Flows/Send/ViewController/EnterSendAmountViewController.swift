//
//  EnterSendAmountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/10/23.
//

import UIKit

class EnterSendAmountViewController: UIViewController {
	// MARK: - Public Properties

	// MARK: Private Properties

	private let enterAmountVM: EnterSendAmountViewModel
	private let assets: [AssetViewModel]

	// MARK: Initializers

	init(selectedAsset: AssetViewModel, assets: [AssetViewModel]) {
		self.enterAmountVM = EnterSendAmountViewModel(selectedToken: selectedAsset)
		self.assets = assets
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

	override func viewWillDisappear(_ animated: Bool) {
		// Save selected assets locally
	}

	// MARK: - Private Methods

	private func setupView() {
		view = EnterSendAmountView(
			enterAmountVM: enterAmountVM,
			changeSelectedToken: {
				self.openSelectAssetPage()
			},
			nextButtonTapped: {
				let qrScanner = QRScannerViewController()
				self.present(qrScanner, animated: true)
			}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Enter amount")
	}

	private func openSelectAssetPage() {
		let selectAssetVC = SelectAssetToSendViewController(assets: assets)
		selectAssetVC.changeAssetFromEnterAmountPage = { selectAsset in
			self.enterAmountVM.selectedToken = selectAsset
		}
		let selectAssetNavigationController = UINavigationController(rootViewController: selectAssetVC)
		present(selectAssetNavigationController, animated: true)
	}
}
