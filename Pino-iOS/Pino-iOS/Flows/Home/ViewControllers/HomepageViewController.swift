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
	private var cancellables = Set<AnyCancellable>()
	private var addressCopiedToastView = PinoToastView(message: nil, style: .primary, alignment: .top)

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidLayoutSubviews() {
		let gradientLayer = GradientLayer(frame: view.bounds, style: .homeBackground)
		view.layer.insertSublayer(gradientLayer, at: 0)
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = UIView()
		let assetsCollectionView = AssetsCollectionView(homeVM: homeVM)
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
		}.store(in: &cancellables)

		navigationItem.rightBarButtonItem = WalletInfoNavigationItems.manageAssetButton
		navigationItem.rightBarButtonItem?.target = self
		navigationItem.rightBarButtonItem?.action = #selector(openManageAssetsPage)

		navigationItem.titleView?
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyWalletAddress)))
	}

	@objc
	private func copyWalletAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = homeVM.walletInfo.address

		addressCopiedToastView.showToast()
	}

	@objc
	private func openManageAssetsPage() {
		let manageAssetsVC = ManageAssetsViewController()
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [manageAssetsVC]
		present(navigationVC, animated: true)
	}
}
