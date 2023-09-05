//
//  InvestViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class InvestViewController: UIViewController {
	// MARK: - Private Properties

	private var investView: InvestView!
	private let investVM = InvestViewModel()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		investView.addAssetsGradient()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		investView = InvestView(
			investVM: investVM,
			totalInvestmentTapped: {
				self.openInvestmentBoard()
			},
			investmentPerformanceTapped: {
				self.openInvestmentPerformance()
			}
		)
		view = InvestEmptyPageView(startInvestingDidTap: {})
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Invest")
	}

	private func openInvestmentBoard() {
		let investmentBoardVC = InvestmentBoardViewController(assets: investVM.assets)
		let investmentBoardNavigationVC = UINavigationController(rootViewController: investmentBoardVC)
		present(investmentBoardNavigationVC, animated: true)
	}

	private func openInvestmentPerformance() {
		let investmentPerformanceVC = InvestmentPerformanceViewController(assets: investVM.assets)
		let investmentPerformanceNavigationVC = UINavigationController(rootViewController: investmentPerformanceVC)
		present(investmentPerformanceNavigationVC, animated: true)
	}
}
