//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class CoinInfoViewController: UIViewController {
	// MARK: - Private Properties

	private var coinInfoVM: CoinInfoViewModel!

	// MARK: - Initializers

	init(coinID: String, homeVM: HomepageViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coinInfoVM = CoinInfoViewModel(homeVM: homeVM, coinID: coinID)
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
		view = CoinInfoCollectionView(coinInfoVM: coinInfoVM)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("\(coinInfoVM.coinPortfolio.symbol)")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissCoinInfo)
		)
	}

	@objc
	private func dismissCoinInfo() {
		dismiss(animated: true)
	}

}
