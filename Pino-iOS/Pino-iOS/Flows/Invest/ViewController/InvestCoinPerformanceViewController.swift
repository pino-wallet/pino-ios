//
//  CoinPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation
import UIKit

class InvestCoinPerformanceViewController: UIViewController {
	// MARK: Private Properties

	private var coinPerformanceVM: InvestCoinPerformanceViewModel

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.coinPerformanceVM = InvestCoinPerformanceViewModel(selectedAsset: selectedAsset)
		super.init(nibName: nil, bundle: nil)
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
		view = InvestCoinPerformanceView(coinPerformanceVM: coinPerformanceVM)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle(coinPerformanceVM.assetName)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}
}