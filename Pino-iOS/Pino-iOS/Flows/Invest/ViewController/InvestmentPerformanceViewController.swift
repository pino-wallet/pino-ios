//
//  InvestmentViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import UIKit

class InvestmentPerformanceViewController: UIViewController {
	// MARK: - Private Properties

	private var investmentPerformaneVM: InvestmentPerformanceViewModel!

	// MARK: Initializers

	init(assets: [InvestAssetViewModel]?) {
		super.init(nibName: nil, bundle: nil)
		self.investmentPerformaneVM = InvestmentPerformanceViewModel(assets: assets, chartDateFilterDelegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		SyncWalletViewModel.showToastIfSyncIsNotFinished()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if SyncWalletViewModel.isSyncFinished {
			getInvestmentPerformance()
		} else {
			showSkeletonLoading()
		}
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = InvestmentPerformanceCollectionView(
			investmentPerformanceVM: investmentPerformaneVM,
			assetSelected: { shareOfAsset in
				if let shareOfAsset = shareOfAsset as? InvestmentShareOfAssetsViewModel {
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

	private func openCoinPerformancePage(selectedAsset: InvestAssetViewModel) {
		let coinPerformanceVC = InvestCoinPerformanceViewController(selectedAsset: selectedAsset)
		let coinPerformanceNavigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		present(coinPerformanceNavigationVC, animated: true)
	}

	private func showSkeletonLoading() {
		view.showGradientSkeletonView(startLocation: 0.3, endLocation: 0.8)
	}

	private func getInvestmentPerformance() {
		if investmentPerformaneVM.chartVM != nil { return }
		investmentPerformaneVM.getInvestPerformanceData().catch { error in
			self.showErrorToast(error)
		}
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}

extension InvestmentPerformanceViewController: LineChartDateFilterDelegate {
	func chartDateDidChange(_ dateFilter: ChartDateFilter) {
		investmentPerformaneVM.getChartData(dateFilter: dateFilter).catch { error in
			self.showErrorToast(error)
		}
	}
}
