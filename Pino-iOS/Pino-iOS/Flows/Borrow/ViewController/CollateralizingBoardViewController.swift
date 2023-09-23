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

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			collateralizingBoardVM.getCollaterlizableTokens()
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
		collateralizingBoardVM = CollateralizingBoardViewModel(borrowVM: borrowVM)

		collateralizingBoardView = CollateralizingBoradView(
			collateralizingBoardVM: collateralizingBoardVM,
			assetDidSelect: { selectedAssetVM in
				if let selectedAssetVM = selectedAssetVM as? UserCollateralizingAssetViewModel {
					self.presentCollateralDetailsVC(selectedAssetVM: selectedAssetVM.defaultCollateralizingAssetModel)
					#warning("i should use it later")
				} else if let selectedAssetVM = selectedAssetVM as? CollateralizableAssetViewModel {
					self.pushToCollateralIncreaseAmountPage()
				} else {
					print("Unknown type")
				}
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

	private func presentCollateralDetailsVC(selectedAssetVM: UserBorrowingToken) {
		let collateralDetailVM = CollateralDetailsViewModel(collateralledTokenModel: selectedAssetVM)
		let collateralDetailsVC = CollateralDetailsViewController(collateralDetailsVM: collateralDetailVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [collateralDetailsVC]
		present(navigationVC, animated: true)
	}

	#warning("this is for test")
	private func pushToCollateralIncreaseAmountPage() {
		let collateralIncreaseAmountVC = CollateralIncreaseAmountViewController()
		navigationController?.pushViewController(collateralIncreaseAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
