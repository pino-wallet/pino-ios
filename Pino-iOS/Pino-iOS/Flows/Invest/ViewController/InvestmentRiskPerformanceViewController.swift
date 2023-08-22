//
//  InvestmentRiskPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/22/23.
//

import UIKit

class InvestmentRiskPerformanceViewController: UIViewController {
	// MARK: - Private Properties

	// MARK: - Initializers

	init(investableAsset: InvestableAssetViewModel) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = InvestmentRiskPerformanceView(viewDidDissmiss: {
			self.closePage()
		})
	}

	private func closePage() {
		dismiss(animated: true)
	}
}
