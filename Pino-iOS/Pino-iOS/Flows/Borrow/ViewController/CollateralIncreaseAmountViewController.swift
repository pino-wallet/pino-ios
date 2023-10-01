//
//  CollateralIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class CollateralIncreaseAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel
	private var collateralIncreaseAmountView: CollateralIncreaseAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: Initializers

	init(collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel) {
		self.collateralIncreaseAmountVM = collateralIncreaseAmountVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
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

	private func pushToCollateralConfirmVC() {
		let collateralConfirmVM = CollateralConfirmViewModel(collaterallIncreaseAmountVM: collateralIncreaseAmountVM)
		let collateralConfirmVC = CollateralConfirmViewController(collateralConfirmVM: collateralConfirmVM)
		navigationController?.pushViewController(collateralConfirmVC, animated: true)
	}
}
