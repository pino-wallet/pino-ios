//
//  InvestDetailViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import UIKit

class InvestmentDetailViewController: UIViewController {
	// MARK: - Private Properties

	// MARK: - Initializers

	init(selectedAsset: InvestAssetViewModel) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = UIView()
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("investment details")
	}
}
