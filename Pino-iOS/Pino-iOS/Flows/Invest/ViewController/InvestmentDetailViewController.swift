//
//  InvestDetailViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import UIKit

class InvestmentDetailViewController: UIViewController {
	// MARK: - Private Properties

	private let selectedAsset: InvestAssetViewModel
	private let investmentDetailsVM: InvestmentDetailViewModel

	// MARK: - Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
		self.investmentDetailsVM = InvestmentDetailViewModel(selectedAsset: selectedAsset)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = InvestmentDeatilsView(
			investmentDetailsVM: investmentDetailsVM,
			increaseInvestmentDidTap: {},
			withdrawDidTap: {}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(investmentDetailsVM.pageTitle)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "chart"),
			style: .plain,
			target: self,
			action: #selector(openChartPage)
		)
	}

	@objc
	private func openChartPage() {
		let coinPerformanceVC = InvestCoinPerformanceViewController(selectedAsset: selectedAsset)
		let coinPerformanceNavigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		present(coinPerformanceNavigationVC, animated: true)
	}
}
