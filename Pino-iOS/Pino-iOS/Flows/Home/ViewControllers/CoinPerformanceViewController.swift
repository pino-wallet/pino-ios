//
//  CoinPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import UIKit

class CoinPerformanceViewController: UIViewController {
	// MARK: Private Properties

	private let coinPerformanceVM: CoinPerformanceViewModel
	private let hapticManager = HapticManager()

	// MARK: Initializers

	init(selectedAsset: AssetViewModel) {
		self.coinPerformanceVM = CoinPerformanceViewModel(selectedAsset: selectedAsset)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		SyncWalletViewModel.showToastIfSyncIsNotFinished()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		if SyncWalletViewModel.isSyncFinished {
			getCoinPerformance()
		}
		if isBeingPresented || isMovingToParent {
			view.showSkeletonView()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		view = CoinPerformanceView(coinPerformanceVM: coinPerformanceVM, chartDateFilterDelegate: self)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle(coinPerformanceVM.navigationTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
	}

	@objc
	private func closePage() {
		hapticManager.run(type: .selectionChanged)
		dismiss(animated: true)
	}

	private func getCoinPerformance() {
		if coinPerformanceVM.chartVM != nil { return }
		coinPerformanceVM.getCoinPerformance().catch { error in
			self.showErrorToast(error)
		}
	}

	private func showErrorToast(_ error: Error) {
		guard let error = error as? ToastError else { return }
		Toast.default(title: error.toastMessage, style: .error).show(haptic: .warning)
	}
}

extension CoinPerformanceViewController: LineChartDateFilterDelegate {
	func chartDateDidChange(_ dateFilter: ChartDateFilter) {
		hapticManager.run(type: .selectionChanged)
		coinPerformanceVM.getChartData(dateFilter: dateFilter).catch { error in
			self.showErrorToast(error)
		}
	}
}
