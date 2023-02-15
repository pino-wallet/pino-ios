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

		#warning("need to refactore this connect to api.")
		var coinTitle: UILabel {
			let coinTitle = PinoLabel(style: .title, text: nil)
			coinTitle.font = .PinoStyle.semiboldBody
			coinTitle.text = coinInfoVM.coinInfo.name
			coinTitle.textColor = UIColor.Pino.white
			return coinTitle
		}

		navigationItem.titleView = coinTitle

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "chart"),
			style: .plain,
			target: self,
			action: nil
		)

		navigationItem.rightBarButtonItem?.tintColor = .Pino.white
	}

	@objc
	func closePage() {
		dismiss(animated: true)
	}
}
