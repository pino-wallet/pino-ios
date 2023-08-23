//
//  InvestmentRiskPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/22/23.
//

import UIKit

class InvestmentRiskPerformanceViewController: UIViewController {
	// MARK: - Private Properties

	private let investableAsset: InvestableAssetViewModel
    private let viewDidDismiss: () -> Void

	// MARK: - Initializers

    init(investableAsset: InvestableAssetViewModel, viewDidDismiss: @escaping () -> Void) {
		self.investableAsset = investableAsset
        self.viewDidDismiss = viewDidDismiss
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
        let investmentRiskVM = InvestmentRiskPerformanceViewModel(selectedAsset: investableAsset)
		view = InvestmentRiskPerformanceView(
			investmentRiskVM: investmentRiskVM,
			viewDidDismiss: {
                self.closePage()
                self.viewDidDismiss()
			}
		)
	}

	private func closePage() {
		dismiss(animated: true)
	}
}
