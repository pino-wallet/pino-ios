//
//  BorrowLoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import UIKit

class BorrowLoanDetailsViewController: UIViewController {
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

	init(borrowLoanDetailsVM: BorrowLoanDetailsViewModel) {
		self.borrowLoanDetailsVM = borrowLoanDetailsVM

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
				self.pushToBorrowIncreaseAmountPage()
			},
			pushToRepayAmountPageClosure: {
				self.pushToRepayAmountPage()
			}
		)

		view = borrowLoanDetailsView
	}

	#warning("this is for test")
	private func pushToBorrowIncreaseAmountPage() {
		let borrowIncreaseAmountVC = BorrowIncreaseAmountViewController()
		navigationController?.pushViewController(borrowIncreaseAmountVC, animated: true)
	}

	#warning("this is for test")
	private func pushToRepayAmountPage() {
		let repayAmountVC = RepayAmountViewController()
		navigationController?.pushViewController(repayAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
