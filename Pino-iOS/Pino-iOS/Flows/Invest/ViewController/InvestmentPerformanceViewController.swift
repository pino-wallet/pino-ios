//
//  InvestmentViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import UIKit

class InvestmentPerformanceViewController: UIViewController {
	// MARK: - Private Properties

	private let assets: [InvestAssetViewModel]

	// MARK: Initializers

	init(assets: [InvestAssetViewModel]) {
		self.assets = assets
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
		let investmentPerformaneVM = InvestmentPerformanceViewModel(assets: assets)
		view = InvestmentPerformanceCollectionView(
			investmentPerformanceVM: investmentPerformaneVM,
			assetSelected: { shareOfAsset in
				if let shareOfAsset = shareOfAsset as? ShareOfAssetsViewModel {
					self.openCoinPerformancePage(selectedAsset: shareOfAsset.assetVM)
				} else {
					// Incase we decided to add a special page for assets which contain
					// very few amount we can open its page from here
				}
			}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Investment performance")
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

	private func openCoinPerformancePage(selectedAsset: AssetViewModel) {}
}
