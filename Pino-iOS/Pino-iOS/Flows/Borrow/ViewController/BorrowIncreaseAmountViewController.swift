//
//  BorrowIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class BorrowIncreaseAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel
	private var borrowIncreaseAmountView: BorrowIncreaseAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Initializers

	init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel) {
		self.borrowIncreaseAmountVM = borrowIncreaseAmountVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		borrowIncreaseAmountView = BorrowIncreaseAmountView(
			borrowIncreaseAmountVM: borrowIncreaseAmountVM,
			nextButtonTapped: {
				self.pushToBorrowConfirmVC()
			}
		)

		view = borrowIncreaseAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle("\(borrowIncreaseAmountVM.pageTitleBorrowText) \(borrowIncreaseAmountVM.tokenSymbol)")
	}

	private func pushToBorrowConfirmVC() {
        let borrowConfirmVM = BorrowConfirmViewModel(borrowIncreaseAmountVM: borrowIncreaseAmountVM)
		let borrowConfirmVC = BorrowConfirmViewController(borrowConfirmVM: borrowConfirmVM)
		navigationController?.pushViewController(borrowConfirmVC, animated: true)
	}
}
