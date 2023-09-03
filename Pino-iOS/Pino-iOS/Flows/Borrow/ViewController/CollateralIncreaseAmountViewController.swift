//
//  CollateralIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class CollateralIncreaseAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let collateralIncreaseAmountVM = CollateralIncreaseAmountViewModel()
	private var collateralIncreaseAmountView: CollateralIncreaseAmountView!

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
		collateralIncreaseAmountView = CollateralIncreaseAmountView(
			collateralIncreaseAmountVM: collateralIncreaseAmountVM,
			nextButtonTapped: {
                self.pushToCollateralConfirmVC()
            }
		)

		view = collateralIncreaseAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle(
			"\(collateralIncreaseAmountVM.pageTitleCollateralText) \(collateralIncreaseAmountVM.tokenSymbol)"
		)
	}
    
    
    #warning("this should be changed")
    private func pushToCollateralConfirmVC() {
        let collateralConfirmVC = CollateralConfirmViewController()
        navigationController?.pushViewController(collateralConfirmVC, animated: true)
    }
}
