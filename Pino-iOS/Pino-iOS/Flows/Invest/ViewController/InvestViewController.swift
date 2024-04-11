//
//  InvestViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import Combine
import UIKit

class InvestViewController: UIViewController {
	// MARK: - Private Properties

	private var investView: InvestView!
	private var investEmptyPageView: InvestEmptyPageView!
	private let investVM = InvestViewModel()
	private var cancellables = Set<AnyCancellable>()
	private var isWalletSyncFinished: Bool {
		SyncWalletViewModel.isSyncFinished
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if isWalletSyncFinished {
			investVM.getInvestData().catch { error in
				self.showErrorToast(error)
			}
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		investView.setupGradients()
		SyncWalletViewModel.showToastIfSyncIsNotFinished()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
		setupBinding()
	}

	// MARK: - Private Methods

	private func setupView() {
		investEmptyPageView = InvestEmptyPageView(
			startInvestingDidTap: {
				self.startInvesting()
			}
		)

		investView = InvestView(
			investVM: investVM,
			totalInvestmentTapped: {
				self.openInvestmentBoard()
			},
			investmentPerformanceTapped: {
				self.openInvestmentPerformance()
			}
		)

		view = investView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Invest")
	}

	private func setupBinding() {
		investVM.$assets.sink { assets in
			guard self.isWalletSyncFinished else { return }
			if let assets, assets.isEmpty {
				self.view = self.investEmptyPageView
			} else {
				self.investView.reloadInvestments(assets)
				self.view = self.investView
			}
		}.store(in: &cancellables)
	}

	private func openInvestmentBoard() {
		if isWalletSyncFinished && investVM.assets == nil {
			return
		}
		let investmentBoardVC = InvestmentBoardViewController(
			assets: investVM.assets,
			onDepositConfirm: { pageStatus in
				if pageStatus == .pending {
					self.tabBarController?.selectedIndex = 4
				}
				self.dismiss(animated: true)
			}
		)
		let investmentBoardNavigationVC = UINavigationController(rootViewController: investmentBoardVC)
		present(investmentBoardNavigationVC, animated: true)
	}

	private func openInvestmentPerformance() {
		if isWalletSyncFinished && investVM.assets == nil {
			return
		}
		let investmentPerformanceVC = InvestmentPerformanceViewController(assets: investVM.assets)
		let investmentPerformanceNavigationVC = UINavigationController(rootViewController: investmentPerformanceVC)
		present(investmentPerformanceNavigationVC, animated: true)
	}

	private func startInvesting() {
		openInvestmentBoard()
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? APIError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}
