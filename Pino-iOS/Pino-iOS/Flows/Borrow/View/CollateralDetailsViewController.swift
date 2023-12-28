//
//  LoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class CollateralDetailsViewController: UIViewController {
    // MARK: - TypeAliases
    typealias onDismissClosureType = (SendTransactionStatus) -> Void
    // MARK: - Closures
    private let onDismiss: onDismissClosureType
	// MARK: - Private Properties

	private let collateralDetailsVM: CollateralDetailsViewModel
	private var collateralDetailsView: CollateralDetailsView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Initializers

    init(collateralDetailsVM: CollateralDetailsViewModel, onDismiss: @escaping onDismissClosureType) {
		self.collateralDetailsVM = collateralDetailsVM
        self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(collateralDetailsVM.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: collateralDetailsVM.dismissIconName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	private func setupView() {
		collateralDetailsView = CollateralDetailsView(
			collateralDetailsVM: collateralDetailsVM,
			pushToBorrowIncreaseAmountPageClosure: {
				self.pushToCollateralIncreaseAmountPage()
			}, pushToWithdrawAmountPageClosure: {
				self.pushToWithdrawAmountPage()
			}
		)

		view = collateralDetailsView
	}

	private func pushToCollateralIncreaseAmountPage() {
		let collateralIncreaseAmountVM = CollateralIncreaseAmountViewModel(
			selectedToken: collateralDetailsVM
				.foundCollateralledToken,
			borrowVM: collateralDetailsVM.borrowVM, collateralMode: .increase
		)
		let collateralIncreaseAmountVC =
        CollateralIncreaseAmountViewController(collateralIncreaseAmountVM: collateralIncreaseAmountVM, onDismiss: { pageStatus in
            self.onDismiss(pageStatus)
        })
		navigationController?.pushViewController(collateralIncreaseAmountVC, animated: true)
	}

	private func pushToWithdrawAmountPage() {
		let withdrawAmountVM = WithdrawAmountViewModel(
			borrowVM: collateralDetailsVM.borrowVM, userCollateralledTokenID: collateralDetailsVM
				.collateralledTokenID
		)
        let withdrawAmountVC = WithdrawAmountViewController(withdrawAmountVM: withdrawAmountVM, onDismiss: { pageStatus in
            self.onDismiss(pageStatus)
        })
		navigationController?.pushViewController(withdrawAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
