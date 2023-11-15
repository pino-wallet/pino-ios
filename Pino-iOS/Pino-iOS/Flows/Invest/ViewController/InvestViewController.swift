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
	private let investEmptyPageVM = InvestEmptyPageViewModel()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		investView.setupGradients()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		let investEmptyPageView = InvestEmptyPageView(
			investEmptyPageVM: investEmptyPageVM,
			startInvestingDidTap: {
				self.startInvesting()
			}
		)

		investView = InvestView(
			investVM: investVM,
			totalInvestmentTapped: {
				self.openInvestmentBoard()
			},
			investmentPerformanceTapped: {
				self.openInvestmentPerformance()
			},
			investmentIsEmpty: {
				self.view = investEmptyPageView
			}
		)

		if let assets = investVM.assets, assets.isEmpty {
			view = investEmptyPageView
		} else {
			view = investView
		}
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Invest")
	}

	private func openInvestmentBoard() {
		guard let assets = investVM.assets else { return }
		let investmentBoardVC = InvestmentBoardViewController(assets: assets)
		let investmentBoardNavigationVC = UINavigationController(rootViewController: investmentBoardVC)
		present(investmentBoardNavigationVC, animated: true)
	}

	private func openInvestmentPerformance() {
		guard let assets = investVM.assets else { return }
		let investmentPerformanceVC = InvestmentPerformanceViewController(assets: assets)
		let investmentPerformanceNavigationVC = UINavigationController(rootViewController: investmentPerformanceVC)
		present(investmentPerformanceNavigationVC, animated: true)
	}

	private func startInvesting() {
		openInvestmentBoard()
	}
}
