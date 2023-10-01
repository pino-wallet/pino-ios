//
//  WithdrawAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class WithdrawAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let withdrawAmountVM: WithdrawAmountViewModel
	private var withdrawAmountView: WithdrawAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Initializers

	init(withdrawAmountVM: WithdrawAmountViewModel) {
		self.withdrawAmountVM = withdrawAmountVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
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

	private func pushToWithdrawConfirmVC() {
		let withdrawConfirmVM = WithdrawConfirmViewModel(withdrawAmountVM: withdrawAmountVM)
		let withdrawConfirmVC = WithdrawConfirmViewController(withdrawConfirmVM: withdrawConfirmVM)
		navigationController?.pushViewController(withdrawConfirmVC, animated: true)
	}
}
