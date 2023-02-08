//
//  AddCustomAssetViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetViewController: UIViewController {
	// MARK: - Initializers

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

	private func setupView() {
		let addCustomAssetView =
			AddCustomAssetView(presentTooltipAlertClosure: { [weak self] tooltipTitle, tooltipDescription in
				let tooltipAlert = InfoActionSheet(title: tooltipTitle, description: tooltipDescription)
				self?.present(tooltipAlert, animated: true)
			})
		view = addCustomAssetView
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup navigation title
		setNavigationTitle("Add custom asset")

		// Setup dismiss button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "arrow_left"), style: .plain, target: self,
			action: #selector(dismissAddCustomAssetVC)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white

		// Setup add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Add",
			style: .plain,
			target: self,
			action: #selector(addCustomAssetHandler)
		)
	}

	// Setup dismiss button handler
	@objc
	private func dismissAddCustomAssetVC() {
		dismiss(animated: true)
	}

	// Setup add button handler
	@objc
	private func addCustomAssetHandler() {
		print("added")
	}
}
