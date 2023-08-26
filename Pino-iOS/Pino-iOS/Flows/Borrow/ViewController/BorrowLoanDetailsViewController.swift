//
//  BorrowLoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import UIKit

class BorrowLoanDetailsViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowLoanDetailsVM = BorrowLoanDetailsViewModel()
	private var borrowLoanDetailsView: BorrowLoanDetailsView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
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
		borrowLoanDetailsView = BorrowLoanDetailsView(borrowLoanDetailsVM: borrowLoanDetailsVM)

		view = borrowLoanDetailsView
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
