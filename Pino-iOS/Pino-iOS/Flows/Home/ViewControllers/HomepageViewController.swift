//
//  HomepageViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import Combine
import UIKit

class HomepageViewController: UIViewController {
	// MARK: - Private Properties

	private var homeVM: HomepageViewModel!
	private var profileVM: ProfileViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var assetsCollectionView: AssetsCollectionView!

	// MARK: - View Overrides

	override func viewDidAppear(_ animated: Bool) {
		assetsCollectionView.getHomeData()
	}

	override func viewDidLayoutSubviews() {
		let gradientLayer = GradientLayer(frame: view.bounds, style: .homeBackground)
		view.layer.insertSublayer(gradientLayer, at: 0)
	}

	override func loadView() {
		homeVM = HomepageViewModel()
		profileVM = ProfileViewModel(walletInfo: homeVM.walletInfo)

		setupView()
		setupNavigationBar()
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		assetsCollectionView = AssetsCollectionView(
			homeVM: homeVM,
			manageAssetButtonTapped: { [weak self] in
				self?.openManageAssetsPage()
			},
			assetTapped: { [weak self] assetVM in
				self?.openCoinInfo(assetVM: assetVM)
			},
			receiveButtonTappedClosure: { [weak self] in
				self?.openReceiveAssetPage()
			},
			sendButtonTappedClosure: { [weak self] in
				self?.openSendAssetPage()
			},
			portfolioPerformanceTapped: {
				self.openPortfolioPage()
			}
		)
		view = UIView()
		view.addSubview(assetsCollectionView)
		assetsCollectionView.pin(.allEdges)
	}

	private func setupNavigationBar() {
		homeVM.$walletBalance.sink { walletBalance in
			self.profileVM.walletBalance = walletBalance?.balance
		}.store(in: &cancellables)

		homeVM.$walletInfo.sink { [weak self] accountInfo in
			guard let accountInfo = accountInfo else { return }
			let accountInfoNavigationItems = AccountInfoNavigationItems(accountInfoVM: accountInfo)
			self?.navigationItem.titleView = accountInfoNavigationItems.accountTitle
			self?.navigationItem.leftBarButtonItem = accountInfoNavigationItems.profileButton
			self?.navigationItem.titleView?
				.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.openAccountsPage)))
			self?.navigationItem.titleView?
				.addGestureRecognizer(UILongPressGestureRecognizer(
					target: self,
					action: #selector(self?.copyWalletAddress)
				))
			self?.navigationItem.leftBarButtonItem?.customView?
				.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.openProfilePage)))
		}.store(in: &cancellables)

		navigationItem.rightBarButtonItem = AccountInfoNavigationItems.manageAssetButton
		navigationItem.rightBarButtonItem?.target = self
		navigationItem.rightBarButtonItem?.action = #selector(openManageAssetsPage)
	}

	private func setupBindings() {
		profileVM.$walletInfo.sink { walletInfo in
			self.homeVM.walletInfo = walletInfo
		}.store(in: &cancellables)
	}

	@objc
	private func copyWalletAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = homeVM.walletInfo.address

		Toast.default(title: GlobalToastTitles.copy.message, style: .copy, direction: .top).show(haptic: .success)
	}

	@objc
	private func openAccountsPage() {
		#warning("this should open accounts page in next pr")
	}

	@objc
	private func openManageAssetsPage() {
		if GlobalVariables.shared.manageAssetsList != nil {
			let manageAssetsVC = ManageAssetsViewController(homeVM: homeVM)
			let navigationVC = UINavigationController()
			navigationVC.viewControllers = [manageAssetsVC]
			navigationVC.modalPresentationStyle = .formSheet
			present(navigationVC, animated: true)
		}
	}

	@objc
	private func openProfilePage() {
		let profileVC = ProfileViewController(profileVM: profileVM)
		let navigationVC = UINavigationController()
		navigationVC.modalPresentationStyle = .formSheet
		navigationVC.viewControllers = [profileVC]
		present(navigationVC, animated: true)
	}

	private func openCoinInfo(assetVM: AssetViewModel) {
		let coinInfoVC = CoinInfoViewController(selectedAsset: assetVM, homeVM: homeVM)
		let navigationVC = UINavigationController(rootViewController: coinInfoVC)
		navigationVC.modalPresentationStyle = .formSheet
		present(navigationVC, animated: true)
	}

	private func openPortfolioPage() {
		guard let assets = GlobalVariables.shared.selectedManageAssetsList?.filter({ $0.isVerified }) else { return }
		let portfolioPerformanceVC = PortfolioPerformanceViewController(assets: assets)
		portfolioPerformanceVC.modalPresentationStyle = .formSheet
		let navigationVC = UINavigationController(rootViewController: portfolioPerformanceVC)
		present(navigationVC, animated: true)
	}

	private func openReceiveAssetPage() {
		let navigationVC = UINavigationController()
		let receiveAssetVC = ReceiveAssetViewController(accountInfo: homeVM.walletInfo)
		navigationVC.viewControllers = [receiveAssetVC]
		navigationVC.modalPresentationStyle = .formSheet
		present(navigationVC, animated: true)
	}

	private func openSendAssetPage() {
		if let assetsList = GlobalVariables.shared.selectedManageAssetsList {
			let navigationVC = UINavigationController()
			let selectAssetToSendVC = SelectAssetToSendViewController(assets: assetsList)
			navigationVC.viewControllers = [selectAssetToSendVC]
			present(navigationVC, animated: true)
		}
	}
}
