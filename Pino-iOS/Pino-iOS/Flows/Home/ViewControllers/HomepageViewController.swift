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
	private var addressCopiedToastView: PinoToastView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidLayoutSubviews() {
		setupBackgroundGradientLayer()
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
		setupToastView()
	}

	private func setupBackgroundGradientLayer() {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.locations = [0.3, 0.7]
		gradientLayer.colors = [
			UIColor.Pino.secondaryBackground.cgColor,
			UIColor.Pino.background.cgColor,
		]
		view.layer.insertSublayer(gradientLayer, at: 0)
	}

	private func setupNavigationBar() {
		homeVM.$walletInfo.sink { [weak self] walletInfo in
			guard let walletInfo = walletInfo else { return }
			let walletInfoNavigationItems = WalletInfoNavigationItems(walletInfoVM: walletInfo)
			self?.navigationItem.titleView = walletInfoNavigationItems.walletTitle
			self?.navigationItem.leftBarButtonItem = walletInfoNavigationItems.profileButton
		}.store(in: &cancellables)

		navigationItem.rightBarButtonItem = WalletInfoNavigationItems.manageAssetButton

		(navigationItem.titleView as? UIButton)?.addAction(UIAction(handler: { _ in
			self.copyWalletAddress()
		}), for: .touchUpInside)
	}

	private func setupToastView() {
		addressCopiedToastView = PinoToastView(message: homeVM.copyToastMessage)
		view.addSubview(addressCopiedToastView)

		addressCopiedToastView.pin(
			.top(to: view.layoutMarginsGuide, padding: -16),
			.centerX
		)
	}

	private func copyWalletAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = homeVM.walletInfo.address

		addressCopiedToastView.showToast()
	}
}
