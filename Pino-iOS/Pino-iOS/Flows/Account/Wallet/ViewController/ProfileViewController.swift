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
	private let accountsVM = AccountsViewModel()
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
	}

	private func setupBindings() {
		accountsVM.$accountsList.sink { wallets in
			let selectedWallet = wallets?.first(where: { $0.isSelected })
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
			let walletsVC = AccountsViewController(accountsVM: accountsVM)
			navigationController?.pushViewController(walletsVC, animated: true)
		case .notification:
			let notificationsVC = NotificationSettingsViewController()
			navigationController?.pushViewController(notificationsVC, animated: true)
		case .securityLock:
			let securityLockVC = SecurityViewController()
			navigationController?.pushViewController(securityLockVC, animated: true)
		case .recoverPhrase:
			let recoverPhraseVC = RecoveryPhraseViewController()
			navigationController?.pushViewController(recoverPhraseVC, animated: true)
		case .aboutPino:
			let aboutPino = AboutPinoViewController()
			navigationController?.pushViewController(aboutPino, animated: true)
		default: break
		}
	}
}
