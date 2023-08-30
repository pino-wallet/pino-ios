//
//  LoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class CollateralDetailsViewController: UIViewController {
	// MARK: - Private Properties

	private let collateralDetailsVM = CollateralDetailsViewModel()
	private var collateralDetailsView: CollateralDetailsView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
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
        collateralDetailsView = CollateralDetailsView(collateralDetailsVM: collateralDetailsVM, pushToBorrowIncreaseAmountPageClosure: {
            self.pushToCollateralIncreaseAmountPage()
        })

		view = collateralDetailsView
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
