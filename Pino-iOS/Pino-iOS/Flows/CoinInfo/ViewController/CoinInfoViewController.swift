//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/5/23.
//

import Combine
import UIKit

class CoinInfoViewController: UIViewController {
	// MARK: - Private Properties

	private let coinInfoVM = CoinInfoPageViewModel()

	// MARK: - viewOverrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setUpView()
		setupNavigationBar()
	}

	// MARK: - private Methods

	private func setUpView() {
		view = UIView()
		let coinInfoCollectionView = CoinInfoCollectionView(coinInfoVM: coinInfoVM)
		view = coinInfoCollectionView
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "close"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white
		navigationItem.rightBarButtonItem = CoinInfoNavigationItems.chartButton
		navigationItem.titleView = CoinInfoNavigationItems.coinTitle
	}

	@objc
	func closePage() {
		dismiss(animated: true)
	}
}
