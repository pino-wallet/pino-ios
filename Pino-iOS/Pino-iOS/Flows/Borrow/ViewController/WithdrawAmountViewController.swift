//
//  WithdrawAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class WithdrawAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let withdrawAmountVM = WithdrawAmountViewModel()
	private var withdrawAmountView: WithdrawAmountView!

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
		withdrawAmountView = WithdrawAmountView(withdrawAmountVM: withdrawAmountVM, nextButtonTapped: {
			self.pushToWithdrawConfirmVC()
		})

		view = withdrawAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle(
			"\(withdrawAmountVM.pageTitleWithdrawText) \(withdrawAmountVM.tokenSymbol)"
		)
	}

	#warning("this should be changed")
	private func pushToWithdrawConfirmVC() {
		let withdrawConfirmVC = WithdrawConfirmViewController()
		navigationController?.pushViewController(withdrawConfirmVC, animated: true)
	}
}
