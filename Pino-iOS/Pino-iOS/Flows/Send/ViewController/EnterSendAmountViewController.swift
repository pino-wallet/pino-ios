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
	private var onSendConfirm: (SendTransactionStatus) -> Void

	// MARK: Initializers

	init(
		selectedAsset: AssetViewModel,
		assets: [AssetViewModel],
		onSendConfirm: @escaping (SendTransactionStatus) -> Void
	) {
		self.enterAmountVM = EnterSendAmountViewModel(selectedToken: selectedAsset)
		self.onSendConfirm = onSendConfirm
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
		let filteredAsset = assets.filter { !$0.holdAmount.isZero }
		let selectAssetVC = SelectAssetToSendViewController(assets: filteredAsset, onDismiss: { pageStatus in
			self.onSendConfirm(pageStatus)
		})
		selectAssetVC.changeAssetFromEnterAmountPage = { selectAsset in
			self.enterAmountVM.selectedToken = selectAsset
		}
		let selectAssetNavigationController = UINavigationController(rootViewController: selectAssetVC)
		present(selectAssetNavigationController, animated: true)
	}

	private func openEnterAddressPage() {
		let enterSendAddressVM = EnterSendAddressViewModel(sendAmountVM: enterAmountVM)
		let enterSendAddressVC = EnterSendAddressViewController(
			enterAddressVM: enterSendAddressVM,
			onSendConfirm: { pageStatus in
				self.onSendConfirm(pageStatus)
			}
		)
		navigationController?.pushViewController(enterSendAddressVC, animated: true)
	}
}
