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

	#warning("Temprary adding to test network layer")
	private var usersAPIClient = UsersAPIMockClient()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		usersAPIClient.users().sink { completed in
			switch completed {
			case .finished:
				print("finished")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { users in
			print(users)
		}.store(in: &cancellables)
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

		(navigationItem.titleView as? UIButton)?.addAction(UIAction(handler: { _ in
			self.copyWalletAddress()
		}), for: .touchUpInside)
	}

	private func copyWalletAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = homeVM.walletInfo.address

		addressCopiedToastView.showToast()
	}
}
