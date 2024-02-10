//
//  WithdrawViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit
import Web3

class WithdrawConfirmViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

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

	init(withdrawConfirmVM: WithdrawConfirmViewModel, onDismiss: @escaping onDismissClosureType) {
		self.withdrawConfirmVM = withdrawConfirmVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		withdrawConfirmView = WithdrawConfirmView(
			withdrawConfrimVM: withdrawConfirmVM,
			presentActionSheetClosure: { actionSheet, completion in
				self.presentActionSheet(actionSheet: actionSheet, completion: completion)
			}
		)

		withdrawConfirmVM.confirmWithdrawClosure = { withdrawTRXs in
			self.confirmWithdraw(withdrawTRXs: withdrawTRXs)
		}

		view = withdrawConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(withdrawConfirmVM.pageTitle)
	}

	private func confirmWithdraw(withdrawTRXs: [SendTransactionViewModel]) {
		let withdrawAmountVM = withdrawConfirmVM.withdrawAmountVM
		let withdrawAmountBigNumber = BigNumber(numberWithDecimal: withdrawAmountVM.tokenAmount)
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: withdrawTRXs,
			transactionSentInfoText: "You withdrew  \(withdrawAmountBigNumber!.sevenDigitFormat) \(withdrawAmountVM.selectedToken.symbol) from \(withdrawAmountVM.borrowVM.selectedDexSystem.name) \(withdrawAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(
			sendStatusVM: sendTransactionStatusVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		present(sendTransactionStatusVC, animated: true)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		present(actionSheet, animated: true, completion: completion)
	}
}
