//
//  BorrowConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import UIKit
import Web3

class BorrowConfirmViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

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

	init(borrowConfirmVM: BorrowConfirmViewModel, onDismiss: @escaping onDismissClosureType) {
		self.borrowConfirmVM = borrowConfirmVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		borrowConfirmView = BorrowConfirmView(
			borrowConfirmVM: borrowConfirmVM,
			presentActionSheetClosure: { actionSheet, completion in
				self.presentActionSheet(actionSheet: actionSheet, completion: completion)
			}
		)

		borrowConfirmVM.confirmBorrowClosure = { borrowTRXs in
			self.confirmBorrow(borrowTRXs: borrowTRXs)
		}

		view = borrowConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowConfirmVM.pageTitle)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		present(actionSheet, animated: true, completion: completion)
	}

	private func confirmBorrow(borrowTRXs: [SendTransactionViewModel]) {
		let borrowIncreaseAmountVM = borrowConfirmVM.borrowIncreaseAmountVM
		let borrowAmountBigNumber = BigNumber(numberWithDecimal: borrowIncreaseAmountVM.tokenAmount)
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: borrowTRXs,
			transactionSentInfoText: "You borrowed \(borrowAmountBigNumber!.sevenDigitFormat) \(borrowIncreaseAmountVM.selectedToken.symbol) from \(borrowIncreaseAmountVM.borrowVM.selectedDexSystem.name) \(borrowIncreaseAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(
			sendStatusVM: sendTransactionStatusVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		present(sendTransactionStatusVC, animated: true)
	}
}
