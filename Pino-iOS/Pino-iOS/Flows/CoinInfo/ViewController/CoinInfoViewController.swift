//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class CoinInfoViewController: UIViewController {
	// MARK: - Public Properties

	// MARK: Private Properties

	private let assetVM: AssetViewModel

	// MARK: Initializers

	init(assetVM: AssetViewModel) {
		self.assetVM = assetVM
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
		view = UIView()
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle("\(assetVM.name)")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissCoinInfo)
		)
		// Setup chart button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "chart"),
			style: .plain,
			target: self,
			action: nil
		)
	}

	@objc
	private func dismissCoinInfo() {
		dismiss(animated: true)
	}
}
