//
//  ProfileViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import Combine
import UIKit

class ProfileViewController: UIViewController {
	// MARK: Private Properties

	private let profileVM: ProfileViewModel
	private let walletsVM = WalletsViewModel()
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(profileVM: ProfileViewModel) {
		self.profileVM = profileVM
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
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = ProfileCollectionView(profileVM: profileVM, settingsItemSelected: { settingVM in
			self.openSettingDetail(settingVM: settingVM)
		})
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		navigationController?.navigationBar.backgroundColor = .Pino.primary
		// Setup title view
		setNavigationTitle("Profile")
		// Setup add asset button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(dismissProfile)
		)
		navigationController?.navigationBar.tintColor = .Pino.white
	}

	private func setupBindings() {
		walletsVM.$selectedWallet.sink { selectedWallet in
			self.profileVM.walletInfo = selectedWallet
		}.store(in: &cancellables)
	}

	@objc
	private func dismissProfile() {
		dismiss(animated: true)
	}

	private func openSettingDetail(settingVM: SettingsViewModel) {
		switch settingVM {
		case .wallets:
			let WalletsVC = WalletsViewController(walletVM: walletsVM)
			navigationController?.pushViewController(WalletsVC, animated: true)
		default: break
		}
	}
}
