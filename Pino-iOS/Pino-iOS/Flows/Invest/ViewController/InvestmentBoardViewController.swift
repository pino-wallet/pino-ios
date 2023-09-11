//
//  InvestmentBoardViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import UIKit

class InvestmentBoardViewController: UIViewController {
	// MARK: - Private Properties

	private let assets: [InvestAssetViewModel]
	private var investmentBoardView: InvestmentBoardView!
	private var investmentBoardVM: InvestmentBoardViewModel

	// MARK: Initializers

	init(assets: [InvestAssetViewModel]) {
		self.assets = assets
		self.investmentBoardVM = InvestmentBoardViewModel(userInvestments: assets)
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
		view = InvestmentBoardView(
			investmentBoardVM: investmentBoardVM,
			assetDidSelect: { selectedAsset in
				self.openInvestPage(selectedAsset: selectedAsset)
			},
			filterDidTap: {
				self.openFilterPage()
			}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Investment board")
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

	private func openInvestPage(selectedAsset: AssetsBoardProtocol) {
		if let investableAsset = selectedAsset as? InvestableAssetViewModel {
			openInvestabelAssetPage(investableAsset)
		} else if let userInvestment = selectedAsset as? InvestAssetViewModel {
			openInvestmentDetailPage(userInvestment)
		}
	}

	private func openInvestmentDetailPage(_ userInvestment: InvestAssetViewModel) {
		let investmentDetailVC = InvestmentDetailViewController(selectedAsset: userInvestment)
		navigationController?.pushViewController(investmentDetailVC, animated: true)
	}

	private func openInvestabelAssetPage(_ investableAsset: InvestableAssetViewModel) {
		let riskPerformanceVC = InvestmentRiskPerformanceViewController(investableAsset: investableAsset) {
			let investVC = InvestDepositViewController(
				selectedAsset: investableAsset,
				selectedProtocol: investableAsset.assetProtocol
			)
			let investNavigationVC = UINavigationController(rootViewController: investVC)
			self.present(investNavigationVC, animated: true)
		}
		present(riskPerformanceVC, animated: true)
	}

	private func openFilterPage() {
		let investmentFilterVM = InvestmentBoardFilterViewModel(
			selectedAsset: investmentBoardVM.assetFilter,
			selectedProtocol: investmentBoardVM.protocolFilter,
			selectedRisk: investmentBoardVM.riskFilter,
			filterDelegate: investmentBoardVM
		)
		let investmentBoardFilterVC = InvestmentBoardFilterViewController(filterVM: investmentFilterVM)
		let investmentBoardFilterNavigationVC = UINavigationController(rootViewController: investmentBoardFilterVC)
		present(investmentBoardFilterNavigationVC, animated: true)
	}
}
