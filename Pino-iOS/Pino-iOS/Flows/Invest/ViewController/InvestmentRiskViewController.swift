//
//  InvestmentRiskViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/21/23.
//

import UIKit

class InvestmentRiskViewController: UIViewController {
	// MARK: Private Properties

	private var InvestmentRiskDidSelect: (InvestmentRisk) -> Void

	// MARK: Initializers

	init(InvestmentRiskDidSelect: @escaping (InvestmentRisk) -> Void) {
		self.InvestmentRiskDidSelect = InvestmentRiskDidSelect
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
		view = InvestmentRiskView(riskDidSelect: { selectedRisk in
			self.InvestmentRiskDidSelect(selectedRisk)
			self.closePage()
		})
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Select risk")
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
		navigationController?.navigationBar.tintColor = .Pino.white
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}
}
