//
//  BorrowConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import UIKit
import Web3

class BorrowConfirmViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowConfirmVM: BorrowConfirmViewModel
	private var borrowConfirmView: BorrowConfirmView!

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
			borrowConfirmView.showSkeletonView()
			borrowConfirmVM.getBorrowGasInfo()
		}
	}

	// MARK: - Initializers

	init(borrowConfirmVM: BorrowConfirmViewModel) {
		self.borrowConfirmVM = borrowConfirmVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		borrowConfirmView = BorrowConfirmView(
			borrowConfirmVM: borrowConfirmVM,
			presentActionSheetClosure: { actionSheet in
				self.presentActionSheet(actionSheet: actionSheet)
			}
		)

		borrowConfirmVM.confirmBorrowClosure = { borrowTRX in
			self.confirmBorrow(borrowTRX: borrowTRX)
		}

		view = borrowConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowConfirmVM.pageTitle)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}

	private func confirmBorrow(borrowTRX: EthereumSignedTransaction) {
		let borrowTransaction = SendTransactionViewModel(
			transaction: borrowTRX,
			addPendingActivityClosure: { txHash in
				self.borrowConfirmVM.createBorrowPendingActivity(txHash: txHash)
			}
		)
        let borrowIncreaseAmountVM = borrowConfirmVM.borrowIncreaseAmountVM
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: [borrowTransaction],
            transactionSentInfoText: "You borrowed \(borrowIncreaseAmountVM.tokenAmount.formattedNumberWithCamma) \(borrowIncreaseAmountVM.selectedToken.symbol) from \(borrowIncreaseAmountVM.borrowVM.selectedDexSystem.name) \(borrowIncreaseAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}
}
