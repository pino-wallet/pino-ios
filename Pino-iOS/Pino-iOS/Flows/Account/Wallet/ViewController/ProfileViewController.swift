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
	private let accountsVM: AccountsViewModel
    private let userDefaultsManager = UserDefaultsManager(userDefaultKey: .isInDevMode)
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(profileVM: ProfileViewModel) {
		self.profileVM = profileVM
		self.accountsVM = AccountsViewModel(currentWalletBalance: profileVM.walletBalance)
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

	#warning("This code is temporary and its for to switch between main net and devnet")
	override func becomeFirstResponder() -> Bool {
		true
	}

	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
            let devMode: Bool = userDefaultsManager.getValue() ?? false
            userDefaultsManager.setValue(value: !devMode)
			if devMode {
				Toast.default(title: "DevMode DeActivated", style: .error).show(haptic: .success)
			} else {
				Toast.default(title: "DevMode Activated", style: .error).show(haptic: .success)
			}
		}
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
		setNavigationTitle(profileVM.pageTitle)
		// Setup add asset button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: profileVM.dismissIconName),
			style: .plain,
			target: self,
			action: #selector(dismissProfile)
		)
	}

	@objc
	private func dismissProfile() {
		dismiss(animated: true)
	}

	private func openSettingDetail(settingVM: SettingsViewModel) {
		switch settingVM {
		case .wallets:
			let walletsVC = AccountsViewController(accountsVM: accountsVM, profileVM: profileVM)
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
