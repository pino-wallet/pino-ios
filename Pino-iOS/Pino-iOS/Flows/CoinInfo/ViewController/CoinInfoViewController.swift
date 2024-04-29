//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import UIKit

class CoinInfoViewController: UIViewController {
	// MARK: - Private Properties

	private let hapticManager = HapticManager()
	private var coinInfoVM: CoinInfoViewModel!
	private var coinInfoView: ActivitiesCollectionView!
	private var cancellables = Set<AnyCancellable>()

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
		setupLoading()
	}

	override func viewDidDisappear(_ animated: Bool) {
		coinInfoVM.destroyTimer()
		coinInfoVM.cancellPendingActivitiesBinding()
	}

	// MARK: - Private Methods

	private func setupView() {
		coinInfoView = ActivitiesCollectionView(coinInfoVM: coinInfoVM, openActivityDetails: { [weak self] activityDetails in
			self?.openActivityDetailsPage(activityDetails: activityDetails)
		})
		view = coinInfoView
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("\(coinInfoVM.pageTitle)")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissCoinInfo)
		)

		if coinInfoVM.coinPortfolio.type == .verified {
			navigationItem.rightBarButtonItem = UIBarButtonItem(
				image: UIImage(named: "chart"),
				style: .plain,
				target: self,
				action: #selector(openCoinInfoChartPage)
			)
		}
	}

	private func setupLoading() {
		coinInfoView.$showLoading.sink { showLoading in
			if showLoading {
				self.view.showGradientSkeletonView(endLocation: 0.7)
			} else {
				self.view.hideGradientSkeletonView()
			}
		}.store(in: &cancellables)
	}

	private func openActivityDetailsPage(activityDetails: ActivityCellViewModel) {
		hapticManager.run(type: .lightImpact)
		let navigationVC = UINavigationController()
		let activityDetailsVC = ActivityDetailsViewController(activityDetails: activityDetails)
		navigationVC.viewControllers = [activityDetailsVC]
		present(navigationVC, animated: true)
	}

	@objc
	private func dismissCoinInfo() {
		hapticManager.run(type: .selectionChanged)
		dismiss(animated: true)
	}

	@objc
	private func openCoinInfoChartPage() {
		hapticManager.run(type: .selectionChanged)
		let coinPerformanceVC = CoinPerformanceViewController(selectedAsset: coinInfoVM.selectedAsset)
		let navigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		navigationVC.modalPresentationStyle = .formSheet
		present(navigationVC, animated: true)
	}
}
