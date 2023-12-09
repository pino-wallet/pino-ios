//
//  WithdrawViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit
import Web3

class WithdrawConfirmViewController: UIViewController {
	// MARK: - Private Properties

	private let withdrawConfirmVM: WithdrawConfirmViewModel
	private var withdrawConfirmView: WithdrawConfirmView!

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
			withdrawConfirmView.showSkeletonView()
			withdrawConfirmVM.getWithdrawGasInfo()
		}
	}

	// MARK: - Initializers

	init(withdrawConfirmVM: WithdrawConfirmViewModel) {
		self.withdrawConfirmVM = withdrawConfirmVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		withdrawConfirmView = WithdrawConfirmView(
			withdrawConfrimVM: withdrawConfirmVM,
			presentActionSheetClosure: { actionSheet in
				self.presentActionSheet(actionSheet: actionSheet)
			}
		)

		withdrawConfirmVM.confirmWithdrawClosure = { withdrawTX in
			self.confirmWithdraw(withdrawTRX: withdrawTX)
		}

		view = withdrawConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(withdrawConfirmVM.pageTitle)
	}

	private func confirmWithdraw(withdrawTRX: EthereumSignedTransaction) {
		let withdrawTransaction = SendTransactionViewModel(
			transaction: withdrawTRX,
			addPendingActivityClosure: { txHash in
				self.withdrawConfirmVM.createWithdrawPendingActivity(txHash: txHash)
			}
		)
		let withdrawAmountVM = withdrawConfirmVM.withdrawAmountVM
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: [withdrawTransaction],
			transactionSentInfoText: "You withdrew  \(withdrawAmountVM.tokenAmount.formattedNumberWithCamma) \(withdrawAmountVM.selectedToken.symbol) from \(withdrawAmountVM.borrowVM.selectedDexSystem.name) \(withdrawAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}
