//
//  WithdrawAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class WithdrawAmountViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

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

	init(withdrawAmountVM: WithdrawAmountViewModel, onDismiss: @escaping onDismissClosureType) {
		self.withdrawAmountVM = withdrawAmountVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		withdrawAmountView = WithdrawAmountView(withdrawAmountVM: withdrawAmountVM, nextButtonTapped: {
			self.checkForAllowance()
		})

		view = withdrawAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle(
			"\(withdrawAmountVM.pageTitleWithdrawText) \(withdrawAmountVM.tokenSymbol)"
		)
	}

	private func checkForAllowance() {
		// Check If Permit has access to Token
		withdrawAmountVM.checkTokenAllowance().done { didUserHasAllowance, positionTokenID in
			if didUserHasAllowance {
				self.pushToWithdrawConfirmVC()
			} else {
				self.presentApproveVC(tokenContractAddress: positionTokenID)
			}
		}.catch { error in
			Toast.default(
				title: self.withdrawAmountVM.failedToGetApproveDataErrorText,
				subtitle: GlobalToastTitles.tryAgainToastTitle.message,
				style: .error
			)
			.show(haptic: .warning)
		}
	}

	private func presentApproveVC(tokenContractAddress: String) {
		let approveVC = ApproveContractViewController(
			approveContractID: tokenContractAddress,
			showConfirmVC: {
				self.pushToWithdrawConfirmVC()
			}, approveType: .withdraw
		)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [approveVC]
		present(navigationVC, animated: true)
	}

	private func pushToWithdrawConfirmVC() {
		let withdrawConfirmVM = WithdrawConfirmViewModel(withdrawAmountVM: withdrawAmountVM)
		let withdrawConfirmVC = WithdrawConfirmViewController(
			withdrawConfirmVM: withdrawConfirmVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		navigationController?.pushViewController(withdrawConfirmVC, animated: true)
	}
}
