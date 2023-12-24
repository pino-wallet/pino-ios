//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class CoinInfoViewController: UIViewController {
	// MARK: - Private Properties

	private var coinInfoVM: CoinInfoViewModel!

	// MARK: - Initializers

	init(selectedAsset: AssetViewModel, homeVM: HomepageViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coinInfoVM = CoinInfoViewModel(homeVM: homeVM, selectedAsset: selectedAsset)
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
			coinInfoVM.getUserActivitiesFromVC()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		coinInfoVM.destroyTimer()
		coinInfoVM.cancellPendingActivitiesBinding()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = ActivitiesCollectionView(coinInfoVM: coinInfoVM, openActivityDetails: { [weak self] activityDetails in
			self?.openActivityDetailsPage(activityDetails: activityDetails)
		})
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("\(coinInfoVM.coinPortfolio.symbol)")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissCoinInfo)
		)

		if coinInfoVM.selectedAsset.isVerified, coinInfoVM.selectedAsset.holdAmount > 0.bigNumber {
			navigationItem.rightBarButtonItem = UIBarButtonItem(
				image: UIImage(named: "chart"),
				style: .plain,
				target: self,
				action: #selector(openCoinInfoChartPage)
			)
		}
	}

	private func openActivityDetailsPage(activityDetails: ActivityCellViewModel) {
		let navigationVC = UINavigationController()
		let activityDetailsVC = ActivityDetailsViewController(activityDetails: activityDetails)
		navigationVC.viewControllers = [activityDetailsVC]
		present(navigationVC, animated: true)
	}

	@objc
	private func dismissCoinInfo() {
		dismiss(animated: true)
	}

	@objc
	private func openCoinInfoChartPage() {
		guard coinInfoVM.selectedAsset.holdAmount > 0.bigNumber else { return }
		let coinPerformanceVC = CoinPerformanceViewController(selectedAsset: coinInfoVM.selectedAsset)
		let navigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		navigationVC.modalPresentationStyle = .formSheet
		present(navigationVC, animated: true)
	}
}
