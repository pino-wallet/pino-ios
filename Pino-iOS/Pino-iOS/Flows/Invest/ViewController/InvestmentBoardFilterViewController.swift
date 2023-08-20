//
//  InvestmentBoardFilterViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation
import UIKit

class InvestmentBoardFilterViewController: UIViewController {
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
		let filterVM = InvestmentBoardFilterViewModel()
		view = InvestmentBoardFilterView(
			filterVM: filterVM,
			filterItemSelected: { filterItem in
				self.openFilterItem(filterItem)
			},
			clearFiltersDidTap: {
				self.clearFilters()
			}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Filter")
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

	private func openFilterItem(_ filterItem: InvestmentFilterItemViewModel) {}

	private func clearFilters() {}
}
