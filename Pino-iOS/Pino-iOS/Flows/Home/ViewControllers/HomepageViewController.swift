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

	private let homeVM = HomepageViewModel()
	private var profileVM: ProfileViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var addressCopiedToastView = CopyToastView(message: nil)

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidLayoutSubviews() {
		let gradientLayer = GradientLayer(frame: view.bounds, style: .homeBackground)
		view.layer.insertSublayer(gradientLayer, at: 0)
	}

	override func loadView() {
		profileVM = ProfileViewModel(walletInfo: homeVM.walletInfo)
		setupView()
		setupNavigationBar()
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		let assetsCollectionView = AssetsCollectionView(
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
		addressCopiedToastView.message = homeVM.copyToastMessage
	}

	private func setupNavigationBar() {
		homeVM.$walletInfo.sink { [weak self] walletInfo in
			guard let walletInfo = walletInfo else { return }
			let walletInfoNavigationItems = WalletInfoNavigationItems(walletInfoVM: walletInfo)
			self?.navigationItem.titleView = walletInfoNavigationItems.walletTitle
			self?.navigationItem.leftBarButtonItem = walletInfoNavigationItems.profileButton
			self?.navigationItem.titleView?
				.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.copyWalletAddress)))
			self?.navigationItem.leftBarButtonItem?.customView?
				.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.openProfilePage)))
		}.store(in: &cancellables)

		navigationItem.rightBarButtonItem = WalletInfoNavigationItems.manageAssetButton
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

		addressCopiedToastView.showToast()
	}

	@objc
	private func openManageAssetsPage() {
		let manageAssetsVC = ManageAssetsViewController(homeVM: homeVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [manageAssetsVC]
		present(navigationVC, animated: true)
	}

	@objc
	private func openProfilePage() {
		let profileVC = ProfileViewController(profileVM: profileVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [profileVC]
		present(navigationVC, animated: true)
	}

	private func openCoinInfo(assetVM: AssetViewModel) {
		let coinInfoVC = CoinInfoViewController(coinID: assetVM.id, homeVM: homeVM)
		let navigationVC = UINavigationController(rootViewController: coinInfoVC)
		present(navigationVC, animated: true)
	}

	private func openPortfolioPage() {
		guard let assets = homeVM.manageAssetsList else { return }
		let portfolioPerformanceVC = PortfolioPerformanceViewController(assets: assets)
		portfolioPerformanceVC.modalPresentationStyle = .automatic
		let navigationVC = UINavigationController(rootViewController: portfolioPerformanceVC)
		present(navigationVC, animated: true)
	}

	private func openReceiveAssetPage() {
		let navigationVC = UINavigationController()
		let receiveAssetVC = ReceiveAssetViewController(homeVM: homeVM)
		navigationVC.viewControllers = [receiveAssetVC]
		present(navigationVC, animated: true)
	}

	private func openSendAssetPage() {}
}
