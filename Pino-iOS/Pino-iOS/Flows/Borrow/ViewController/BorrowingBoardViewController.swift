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
		#warning("this values are temporary")
		borrowingBoardVM = BorrowingBoardViewModel(
			userBorrowingTokens: borrowVM.userBorrowingDetails?.borrowTokens.compactMap { _ in
				UserBorrowingAssetModel(
					tokenImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
					tokenSymbol: "USDC",
					userBorrowingAmountInToken: "3000"
				)
			} ?? [],
			borrowableTokens: [
				BorrowableAssetModel(
					tokenImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
					tokenSymbol: "ETH",
					tokenAPY: "30000000000"
				),
			]
		)

		borrowingBoardView = BorrowingBoradView(borrowingBoardVM: borrowingBoardVM, assetDidSelect: { selectedAssetVM in
			if (selectedAssetVM as? UserBorrowingAssetViewModel) != nil {
				self.presentBorrowLoanDetailsVC()
            } else {
                self.pushToBorrowIncreaseAmountPage()
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

	private func presentBorrowLoanDetailsVC() {
		let borrowLoanDetailsVC = BorrowLoanDetailsViewController()
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [borrowLoanDetailsVC]
		present(navigationVC, animated: true)
	}
    
    #warning("this is for test")
    private func pushToBorrowIncreaseAmountPage() {
        let borrowIncreaseAmountVC = BorrowIncreaseAmountViewController()
        navigationController?.pushViewController(borrowIncreaseAmountVC, animated: true)
    }

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
