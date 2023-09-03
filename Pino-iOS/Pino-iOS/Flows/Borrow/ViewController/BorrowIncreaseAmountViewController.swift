//
//  BorrowIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class BorrowIncreaseAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowIncreaseAmountVM = BorrowIncreaseAmountViewModel()
	private var borrowIncreaseAmountView: BorrowIncreaseAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		#warning("this should be changed")
		borrowIncreaseAmountView = BorrowIncreaseAmountView(
			borrowIncreaseAmountVM: borrowIncreaseAmountVM,
			nextButtonTapped: {}
		)

		view = borrowIncreaseAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle("\(borrowIncreaseAmountVM.pageTitleBorrowText) \(borrowIncreaseAmountVM.tokenSymbol)")
	}
}
