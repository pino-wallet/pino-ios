//
//  ProfileViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import UIKit

class ProfileViewController: UIViewController {
	// MARK: - Public Properties

	// MARK: Private Properties

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
		view = ProfileCollectionView(
			accountSettings: [
				SettingViewModel(id: "0", image: "Sand", title: "Wallets", description: nil),
			],
			generalSettings: [
				SettingViewModel(id: "0", image: "Sand", title: "Currency", description: "USD -US Dollar"),
				SettingViewModel(id: "1", image: "Sand", title: "Notification", description: nil),
				SettingViewModel(id: "2", image: "Sand", title: "Security lock", description: nil),
				SettingViewModel(id: "3", image: "Sand", title: "Recover phrase", description: nil),
				SettingViewModel(id: "4", image: "Sand", title: "Support", description: nil),
				SettingViewModel(id: "5", image: "Sand", title: "About pino", description: nil),
			]
		)
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Profile")
		// Setup add asset button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissProfile)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white
	}

	@objc
	private func dismissProfile() {
		dismiss(animated: true)
	}
}
