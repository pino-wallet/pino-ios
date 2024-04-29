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
	private let onDepositConfirm: (SendTransactionStatus) -> Void
	private let hapticManager = HapticManager()

	// MARK: - Initializers

	init(
		selectedAsset: InvestAssetViewModel,
		apy: BigNumber,
		onDepositConfirm: @escaping (SendTransactionStatus) -> Void
	) {
		self.selectedAsset = selectedAsset
		self.investmentDetailsVM = InvestmentDetailViewModel(selectedAsset: selectedAsset, apy: apy)
		self.onDepositConfirm = onDepositConfirm
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

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			hapticManager.run(type: .selectionChanged)
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		view = InvestmentDeatilsView(
			investmentDetailsVM: investmentDetailsVM,
			increaseInvestmentDidTap: {
				self.openInvestPage()
			},
			withdrawDidTap: {
				self.openWithdrawPage()
			}
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
		hapticManager.run(type: .selectionChanged)
		let coinPerformanceVC = InvestCoinPerformanceViewController(selectedAsset: selectedAsset)
		let coinPerformanceNavigationVC = UINavigationController(rootViewController: coinPerformanceVC)
		present(coinPerformanceNavigationVC, animated: true)
	}

	private func openInvestPage() {
		hapticManager.run(type: .lightImpact)
		let depositVM = InvestDepositViewModel(
			selectedAsset: selectedAsset,
			selectedProtocol: selectedAsset.assetProtocol,
			investmentType: .increase
		)
		let investVC = InvestDepositViewController(
			investVM: depositVM,
			onDepositConfirm: onDepositConfirm
		)
		navigationController?.pushViewController(investVC, animated: true)
	}

	private func openWithdrawPage() {
		hapticManager.run(type: .lightImpact)
		let withdrawVM = WithdrawViewModel(
			selectedAsset: selectedAsset,
			selectedProtocol: selectedAsset.assetProtocol
		)
		let withdrawVC = InvestDepositViewController(
			investVM: withdrawVM,
			onDepositConfirm: onDepositConfirm
		)
		navigationController?.pushViewController(withdrawVC, animated: true)
	}
}
