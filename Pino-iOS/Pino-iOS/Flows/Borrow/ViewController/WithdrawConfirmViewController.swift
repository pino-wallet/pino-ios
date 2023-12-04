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
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transaction: withdrawTRX,
			transactionInfo: TransactionInfoModel(
				transactionType: .withdraw,
				transactionDex: withdrawConfirmVM.withdrawAmountVM.borrowVM.selectedDexSystem,
				transactionAmount: withdrawConfirmVM.withdrawAmountVM.tokenAmount,
				transactionToken: withdrawConfirmVM.withdrawAmountVM.selectedToken
			)
		)
		sendTransactionStatusVM.addPendingActivityClosure = { txHash in
			self.withdrawConfirmVM.createWithdrawPendingActivity(txHash: txHash)
		}
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}
