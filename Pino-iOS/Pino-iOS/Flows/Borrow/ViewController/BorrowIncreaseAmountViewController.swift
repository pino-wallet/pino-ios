//
//  BorrowIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class BorrowIncreaseAmountViewController: UIViewController {
    // MARK: - TypeAliases
    typealias onDismissClosureType = (SendTransactionStatus) -> Void
    // MARK: - Closures
    private let onDismiss: onDismissClosureType
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

	init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel, onDismiss: @escaping onDismissClosureType) {
		self.borrowIncreaseAmountVM = borrowIncreaseAmountVM
        self.onDismiss = onDismiss

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
        let borrowConfirmVC = BorrowConfirmViewController(borrowConfirmVM: borrowConfirmVM, onDismiss: { pageStatus in
            self.onDismiss(pageStatus)
        })
		navigationController?.pushViewController(borrowConfirmVC, animated: true)
	}
}
