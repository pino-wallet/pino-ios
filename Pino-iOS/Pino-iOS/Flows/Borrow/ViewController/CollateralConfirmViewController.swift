//
//  CollateralConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit
import Web3

class CollateralConfirmViewController: UIViewController {
	// MARK: - Private Properties

	private let collateralConfirmVM: CollateralConfirmViewModel
	private var collateralConfirmView: CollateralConfirmView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			collateralConfirmView.showSkeletonView()
			collateralConfirmVM.getCollateralGasInfo()
		}
	}

	// MARK: - Initializers

	init(collateralConfirmVM: CollateralConfirmViewModel) {
		self.collateralConfirmVM = collateralConfirmVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		collateralConfirmView = CollateralConfirmView(
			collateralConfrimVM: collateralConfirmVM,
			presentActionSheetClosure: { actionSheet in
				self.presentActionSheet(actionSheet: actionSheet)
			}
		)

		collateralConfirmVM.confirmCollateralClosure = { depositTRX in
			self.confirmCollateral(depositTRX: depositTRX)
		}

		view = collateralConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(collateralConfirmVM.pageTitle)
	}

	private func confirmCollateral(depositTRX: EthereumSignedTransaction) {
		let depositTransaction = SendTransactionViewModel(
			transaction: depositTRX,
			addPendingActivityClosure: { txHash in
				self.collateralConfirmVM.createCollateralPendingActivity(txHash: txHash)
			}
		)
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: [depositTransaction],
			transactionSentInfoText: "You collateralized \(Int(collateralConfirmVM.collaterallIncreaseAmountVM.tokenAmount)!.formattedWithCamma) \(collateralConfirmVM.collaterallIncreaseAmountVM.selectedToken.symbol) in \(collateralConfirmVM.collaterallIncreaseAmountVM.borrowVM.selectedDexSystem.name) \(collateralConfirmVM.collaterallIncreaseAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}
