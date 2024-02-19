//
//  CoinPerformanceViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import UIKit

class CoinPerformanceViewController: UIViewController {
	// MARK: Private Properties

	private let selectedAsset: AssetViewModel

	// MARK: Initializers

	init(selectedAsset: AssetViewModel) {
		self.selectedAsset = selectedAsset
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

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			view.showSkeletonView()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		let coinPerformanceVM = CoinPerformanceViewModel(selectedAsset: selectedAsset)
		view = CoinPerformanceView(coinPerformanceVM: coinPerformanceVM)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle("Coin performance")
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
