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
	private let dismissAndContinue: () -> Void
	private let hapticManager = HapticManager()

	// MARK: - Initializers

	init(investableAsset: InvestableAssetViewModel, viewDidDismiss: @escaping () -> Void) {
		self.investableAsset = investableAsset
		self.dismissAndContinue = viewDidDismiss
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
			dismissAndContinue: {
				self.hapticManager.run(type: .selectionChanged)
				self.closePage()
				self.dismissAndContinue()
			}, dismissView: {
				self.hapticManager.run(type: .selectionChanged)
				self.closePage()
			}
		)
	}

	private func closePage() {
		dismiss(animated: true)
	}
}
