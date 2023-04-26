//
//  PortfolioPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import UIKit

class PortfolioPerformanceViewController: UIViewController {
	// MARK: Initializers

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

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
		let portfolioPerformaneVM = PortfolioPerformanceViewModel()
		view = PortfolioPerformanceCollectionView(
			portfolioPerformanceVM: portfolioPerformaneVM,
			assetSelected: { selectedAsset in
				self.openCoinPerformancePage(selectedAsset: selectedAsset)
			}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Portfolio performance")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
		navigationController?.navigationBar.tintColor = .Pino.white
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}

	private func openCoinPerformancePage(selectedAsset: ShareOfAssetsViewModel) {
		let coinPerformanceVC = CoinPerformanceViewController(selectedAsset: selectedAsset)
		coinPerformanceVC.modalPresentationStyle = .automatic
		let navigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		present(navigationVC, animated: true)
	}
}
