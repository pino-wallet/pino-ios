//
//  CoinInfoChartViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import UIKit

class CoinInfoChartViewController: UIViewController {
	// MARK: Private Properties

	private let coinInfoChartVM = CoinInfoChartViewModel()

	// MARK: Initializers

	init() {
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
		view = CoinInfoChartView(coinInfoChartVM: coinInfoChartVM)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		navigationController?.navigationBar.tintColor = .Pino.white
		// Setup title view
		setNavigationTitle("COMP")
	}
}
