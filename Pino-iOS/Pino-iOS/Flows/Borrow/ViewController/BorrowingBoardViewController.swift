//
//  BorrowingBoardViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import UIKit

class BorrowingBoardViewController: UIViewController {
	// MARK: - Private Properties

	private var borrowVM: BorrowViewModel
	private var borrowingBoardView: BorrowingBoradView!
	private var borrowingBoardVM: BorrowingBoardViewModel!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			borrowingBoardVM.getBorrowableTokens()
		}
	}

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel) {
		self.borrowVM = borrowVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		borrowingBoardVM = BorrowingBoardViewModel(borrowVM: borrowVM)

		borrowingBoardView = BorrowingBoradView(borrowingBoardVM: borrowingBoardVM, assetDidSelect: { selectedAssetVM in
			if let selectedAssetVM = selectedAssetVM as? UserBorrowingAssetViewModel {
				self.presentBorrowLoanDetailsVC(selectedToken: selectedAssetVM.defaultUserBorrowingToken)
			} else if let selectedAssetVM = selectedAssetVM as? BorrowableAssetViewModel {
				self.pushToBorrowIncreaseAmountPage(selectedToken: selectedAssetVM.foundTokenInManageAssetTokens)
			} else {
				print("Unkwon type")
			}
		})

		view = borrowingBoardView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("\(borrowVM.selectedDexSystem.name) \(borrowingBoardVM.loansTitleText)")
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: borrowVM.dismissIconName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	private func presentBorrowLoanDetailsVC(selectedToken: UserBorrowingToken) {
		let borrowLoanDetailsVM = BorrowLoanDetailsViewModel(userBorrowedTokenModel: selectedToken, borrowVM: borrowVM)
		let borrowLoanDetailsVC = BorrowLoanDetailsViewController(borrowLoanDetailsVM: borrowLoanDetailsVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [borrowLoanDetailsVC]
		present(navigationVC, animated: true)
	}

	private func pushToBorrowIncreaseAmountPage(selectedToken: AssetViewModel) {
		let borrowIncreaseAmountVM = BorrowIncreaseAmountViewModel(selectedToken: selectedToken)
		let borrowIncreaseAmountVC = BorrowIncreaseAmountViewController(borrowIncreaseAmountVM: borrowIncreaseAmountVM)
		navigationController?.pushViewController(borrowIncreaseAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
