//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class SecuritySettingsViewController: UIViewController {
	// MARK: - Private Properties

	private let securityVM = SecuritySettingsViewModel()
	private let hapticManager = HapticManager()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(securityVM.pageTitle)
	}

	private func setupView() {
		view = SecurityOptionsCollectionView(
			securityLockVM: securityVM,
			openSelectLockMethodAlertClosure: { [weak self] in
				self?.openLockSelectMethodAlert()
			}
		)
	}

	private func openLockSelectMethodAlert() {
		hapticManager.run(type: .mediumImpact)
		let lockSelectMethodAlert = UIAlertController(
			title: securityVM.changeLockMethodAlertTitle,
			message: "",
			preferredStyle: .actionSheet
		)
		lockSelectMethodAlert.overrideUserInterfaceStyle = .light
		lockSelectMethodAlert
			.addAction(UIAlertAction(title: securityVM.alertCancelButtonTitle, style: .cancel, handler: nil))

		for lockMethod in securityVM.lockMethods {
			let alertAction = UIAlertAction(title: lockMethod.title, style: .default, handler: { [weak self] _ in
				self?.hapticManager.run(type: .mediumImpact)
				self?.securityVM.changeLockMethod(to: lockMethod)
			})
			lockSelectMethodAlert.addAction(alertAction)
		}

		present(lockSelectMethodAlert, animated: true)
	}
}
