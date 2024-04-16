//
//  PortfolioPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import UIKit

class PortfolioPerformanceViewController: UIViewController {
	// MARK: - Private Properties

	private var portfolioPerformaneVM: PortfolioPerformanceViewModel!

	// MARK: Initializers

	init(assets: [AssetViewModel]) {
		super.init(nibName: nil, bundle: nil)
		self.portfolioPerformaneVM = PortfolioPerformanceViewModel(assets: assets, chartDateFilterDelegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if SyncWalletViewModel.isSyncFinished {
			getPortfolioPerformance()
		} else {
			showSkeletonLoading()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		SyncWalletViewModel.showToastIfSyncIsNotFinished()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = PortfolioPerformanceCollectionView(
			portfolioPerformanceVM: portfolioPerformaneVM,
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

	private func openCoinPerformancePage(selectedAsset: AssetViewModel) {
		let coinPerformanceVC = CoinPerformanceViewController(selectedAsset: selectedAsset)
		coinPerformanceVC.modalPresentationStyle = .automatic
		let navigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		present(navigationVC, animated: true)
	}

	private func showSkeletonLoading() {
		view.showGradientSkeletonView(startLocation: 0.3, endLocation: 0.8)
	}

	private func getPortfolioPerformance() {
		if portfolioPerformaneVM.chartVM != nil { return }
		portfolioPerformaneVM.getPortfolioPerformanceData().catch { error in
			self.showErrorToast(error)
		}
	}

	private func showErrorToast(_ error: Error) {
		guard let error = error as? ToastError else { return }
		Toast.default(title: error.toastMessage, style: .error).show(haptic: .warning)
	}
}

extension PortfolioPerformanceViewController: LineChartDateFilterDelegate {
	func chartDateDidChange(_ dateFilter: ChartDateFilter) {
		portfolioPerformaneVM.getChartData(dateFilter: dateFilter).catch { error in
			self.showErrorToast(error)
		}
	}
}
