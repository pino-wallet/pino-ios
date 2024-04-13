//
//  CoinPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation
import UIKit

class InvestCoinPerformanceViewController: UIViewController {
	// MARK: Private Properties

	private var coinPerformanceVM: InvestCoinPerformanceViewModel

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.coinPerformanceVM = InvestCoinPerformanceViewModel(selectedAsset: selectedAsset)
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

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			view.showSkeletonView()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		view = InvestCoinPerformanceView(coinPerformanceVM: coinPerformanceVM, chartDateFilterDelegate: self)

		coinPerformanceVM.getInvestmentPerformanceData().catch { error in
			self.showErrorToast(error)
		}
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle(coinPerformanceVM.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}

extension InvestCoinPerformanceViewController: LineChartDateFilterDelegate {
	func chartDateDidChange(_ dateFilter: ChartDateFilter) {
		coinPerformanceVM.getChartData(dateFilter: dateFilter).catch { error in
			self.showErrorToast(error)
		}
	}
}
