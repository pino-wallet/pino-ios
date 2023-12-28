//
//  BorrowLoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import UIKit

class BorrowLoanDetailsViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

	// MARK: - Private Properties

	private let borrowLoanDetailsVM: BorrowLoanDetailsViewModel
	private var borrowLoanDetailsView: BorrowLoanDetailsView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {
		if borrowLoanDetailsVM.apy == nil {
			borrowLoanDetailsVM.getBorrowableTokenProperties()
			borrowLoanDetailsView.showSkeletonView()
		}
	}

	// MARK: - Initializers

	init(borrowLoanDetailsVM: BorrowLoanDetailsViewModel, onDismiss: @escaping onDismissClosureType) {
		self.borrowLoanDetailsVM = borrowLoanDetailsVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowLoanDetailsVM.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: borrowLoanDetailsVM.dismissIconName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	private func setupView() {
		borrowLoanDetailsView = BorrowLoanDetailsView(
			borrowLoanDetailsVM: borrowLoanDetailsVM,
			pushToBorrowIncreaseAmountPageClosure: {
				self
					.pushToBorrowIncreaseAmountPage(selectedToken: self.borrowLoanDetailsVM.foundBorrowedToken)
			},
			pushToRepayAmountPageClosure: {
				self.pushToRepayAmountPage(selectedTokenID: self.borrowLoanDetailsVM.userBorrowedTokenID)
			}
		)

		view = borrowLoanDetailsView
	}

	private func pushToBorrowIncreaseAmountPage(selectedToken: AssetViewModel) {
		let borrowIncreaseAmountVM = BorrowIncreaseAmountViewModel(
			selectedToken: selectedToken,
			borrowVM: borrowLoanDetailsVM.borrowVM
		)
		let borrowIncreaseAmountVC = BorrowIncreaseAmountViewController(
			borrowIncreaseAmountVM: borrowIncreaseAmountVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		navigationController?.pushViewController(borrowIncreaseAmountVC, animated: true)
	}

	private func pushToRepayAmountPage(selectedTokenID: String) {
		let repayAmountVM = RepayAmountViewModel(
			borrowVM: borrowLoanDetailsVM.borrowVM,
			userBorrowedTokenID: selectedTokenID
		)
		let repayAmountVC = RepayAmountViewController(repayAmountVM: repayAmountVM, onDismiss: { pageStatus in
			self.onDismiss(pageStatus)
		})
		navigationController?.pushViewController(repayAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
