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
		repayConfirmView = RepayConfirmView(repayConfrimVM: repayConfirmVM, presentActionSheetClosure: { actionSheet, completion in
            self.presentActionSheet(actionSheet: actionSheet, completion: completion)
		})

		repayConfirmVM.confirmRepayClosure = { trxs in
			self.confirmRepay(repayTRXs: trxs)
		}

		view = repayConfirmView
	}

	private func confirmRepay(repayTRXs: [SendTransactionViewModel]) {
		let repayAmountVM = repayConfirmVM.repayAmountVM
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: repayTRXs,
			transactionSentInfoText: "You repaid \(repayAmountVM.tokenAmount.formattedNumberWithCamma) \(repayAmountVM.selectedToken.symbol) to \(repayAmountVM.borrowVM.selectedDexSystem.name) \(repayAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(sendStatusVM: sendTransactionStatusVM)
		present(sendTransactionStatusVC, animated: true)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(repayConfirmVM.pageTitle)
	}

    private func presentActionSheet(actionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		present(actionSheet, animated: true, completion: completion)
	}
}
