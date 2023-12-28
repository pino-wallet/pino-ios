//
//  CollateralingBoardViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import UIKit

class CollateralizingBoardViewController: UIViewController {
    // MARK: - TypeAliases
    typealias onDismissClosureType = (SendTransactionStatus) -> Void
    // MARK: - Closures
    private let onDismiss: onDismissClosureType
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

    init(borrowVM: BorrowViewModel, onDismiss: @escaping onDismissClosureType) {
		self.borrowVM = borrowVM
        self.onDismiss = onDismiss

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
					self.presentCollateralDetailsVC(selectedAssetID: selectedAssetVM.userCollaterlizingID)
				} else if let selectedAssetVM = selectedAssetVM as? CollateralizableAssetViewModel {
					self
						.pushToCollateralIncreaseAmountPage(selectedToken: selectedAssetVM.foundCollateralledToken)
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

	private func presentCollateralDetailsVC(selectedAssetID: String) {
		let collateralDetailVM = CollateralDetailsViewModel(borrowVM: borrowVM, collateralledTokenID: selectedAssetID)
        let collateralDetailsVC = CollateralDetailsViewController(collateralDetailsVM: collateralDetailVM, onDismiss: { pageStatus in
            self.onDismiss(pageStatus)
        })
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [collateralDetailsVC]
		present(navigationVC, animated: true)
	}

	private func pushToCollateralIncreaseAmountPage(selectedToken: AssetViewModel) {
		let collateralIncreaseAmountVM = CollateralIncreaseAmountViewModel(
			selectedToken: selectedToken,
			borrowVM: borrowVM,
			collateralMode: .create
		)
		let collateralIncreaseAmountVC =
        CollateralIncreaseAmountViewController(collateralIncreaseAmountVM: collateralIncreaseAmountVM, onDismiss: { pageStatus in
            self.onDismiss(pageStatus)
        })
		navigationController?.pushViewController(collateralIncreaseAmountVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
