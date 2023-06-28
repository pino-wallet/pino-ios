//
//  EnterSendAmountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/10/23.
//

import UIKit

class EnterSendAmountViewController: UIViewController {
	// MARK: Private Properties

	private var enterAmountView: EnterSendAmountView!
	private let enterAmountVM: EnterSendAmountViewModel
	private let assets: [AssetViewModel]

	// MARK: Initializers

	init(selectedAsset: AssetViewModel, assets: [AssetViewModel]) {
		let eth = assets.first(where: { $0.isEth })!
		self.enterAmountVM = EnterSendAmountViewModel(selectedToken: selectedAsset, ethToken: eth)
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

	override func viewDidAppear(_ animated: Bool) {
		enterAmountView.amountTextfield.becomeFirstResponder()
	}

	// MARK: - Private Methods

	private func setupView() {
		enterAmountView = EnterSendAmountView(
			enterAmountVM: enterAmountVM,
			changeSelectedToken: {
				self.openSelectAssetPage()
			},
			nextButtonTapped: {
				self.openEnterAddressPage()
			}
		)
		view = enterAmountView
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

	private func openEnterAddressPage() {
		let eth = assets.first(where: { $0.isEth })!
		let enterSendAddressVM = EnterSendAddressViewModel(sendAmountVM: enterAmountVM)
		let enterSendAddressVC = EnterSendAddressViewController(enterAddressVM: enterSendAddressVM, ethToken: eth)
		navigationController?.pushViewController(enterSendAddressVC, animated: true)
	}
}
