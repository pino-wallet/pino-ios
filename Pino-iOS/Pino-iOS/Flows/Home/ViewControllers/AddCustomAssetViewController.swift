//
//  AddCustomAssetViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetViewController: UIViewController {
	// MARK: - Private Properties

	private let addCustomAssetVM = AddCustomAssetViewModel()

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

	// MARK: - Private Methods

	private func setupView() {
		let addCustomAssetView =
			AddCustomAssetView(
				presentTooltipAlertClosure: { [weak self] tooltipTitle, tooltipDescription in
					let tooltipAlert = InfoActionSheet(title: tooltipTitle, description: tooltipDescription)
					self?.present(tooltipAlert, animated: true)
				},
				dissmissKeybaordClosure: { [weak self] in
					self?.view.endEditing(true)
				},
				addCustomAssetVM: addCustomAssetVM
			)
		view = addCustomAssetView
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup navigation title
		setNavigationTitle(addCustomAssetVM.addcustomAssetPageTitle)

		// Setup dismiss button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: addCustomAssetVM.addCustomAssetPageBackButtonIcon), style: .plain, target: self,
			action: #selector(dismissAddCustomAssetVC)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white

		// Setup add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: addCustomAssetVM.addCustomAssetButtonTitle,
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
