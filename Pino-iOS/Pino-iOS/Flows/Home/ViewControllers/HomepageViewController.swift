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

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = AssetsCollectionView(homeVM: homeVM)
		setupToastView()
	}

	private func setupNavigationBar() {
		homeVM.$walletInfo.sink { [weak self] walletInfo in
			guard let walletInfo = walletInfo else { return }
			let homepageNavigationItems = HomepageNavigationItems(walletInfo: walletInfo)
			self?.navigationItem.titleView = homepageNavigationItems.walletTitle
			self?.navigationItem.leftBarButtonItem = homepageNavigationItems.profileButton
		}.store(in: &cancellables)

		navigationItem.rightBarButtonItem = HomepageNavigationItems.manageAssetButton

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
