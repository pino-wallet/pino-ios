//
//  CollateralingBoardViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import UIKit

class CollateralizingBoardViewController: UIViewController {
	// MARK: - Private Properties

	private var borrowVM: BorrowViewModel
	private var collateralizingBoardView: CollateralizingBoradView!
	private var collateralizingBoardVM: CollateralizingBoardViewModel!

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
		collateralizingBoardVM = CollateralizingBoardViewModel(
			userCollateralizingTokens: borrowVM.userBorrowingDetails?.collateralTokens.compactMap { _ in
				UserCollateralizingAssetModel(
					tokenImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
					tokenSymbol: "USDC",
					userCollateralizedAmountInToken: "3000"
				)
			} ?? [],
			collateralizableTokens: [
				CollateralizableAssetModel(
					tokenImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
					tokenSymbol: "ETH",
					userAmountInToken: "87"
				),
			]
		)

		collateralizingBoardView = CollateralizingBoradView(
			collateralizingBoardVM: collateralizingBoardVM,
			assetDidSelect: { _ in
				self.presentToLoanDetailsVC()
			}
		)

		view = collateralizingBoardView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("\(borrowVM.selectedDexSystem.name) \(collateralizingBoardVM.collateralsTitleText)")
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: borrowVM.dismissIconName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	private func presentToLoanDetailsVC() {
		let loanDetailsVC = LoanDetailsViewController()
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [loanDetailsVC]
		present(navigationVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
