//
//  RepayConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit
import Web3

class RepayConfirmViewController: UIViewController {
	// MARK: - Private Properties

	private let repayConfirmVM: RepayConfirmViewModel
	private var repayConfirmView: RepayConfirmView!

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
			repayConfirmView.showSkeletonView()
			repayConfirmVM.getRepayGasInfo()
		}
	}

	// MARK: - Initializers

	init(repayConfirmVM: RepayConfirmViewModel) {
		self.repayConfirmVM = repayConfirmVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		repayConfirmView = RepayConfirmView(repayConfrimVM: repayConfirmVM, presentActionSheetClosure: { actionSheet in
			self.presentActionSheet(actionSheet: actionSheet)
		})

		repayConfirmVM.confirmRepayClosure = { trxHash in
			self.confirmRepay(repayTRX: trxHash)
		}

		view = repayConfirmView
	}

	private func confirmRepay(repayTRX: EthereumSignedTransaction) {
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transaction: repayTRX,
			transactionInfo: TransactionInfoModel(
				transactionType: .repay,
				transactionDex: repayConfirmVM.repayAmountVM.borrowVM.selectedDexSystem,
				transactionAmount: repayConfirmVM.repayAmountVM.tokenAmount,
				transactionToken: repayConfirmVM.repayAmountVM.selectedToken
			)
		)
		sendTransactionStatusVM.addPendingActivityClosure = { txHash in
			self.repayConfirmVM.createRepayPendingActivity(txHash: txHash)
		}
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(repayConfirmVM.pageTitle)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}
