//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class SecurityViewController: UIViewController {
	// MARK: - Private Properties

	private let securityVM = SecurityViewModel()

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
		let lockSelectMethodAlert = UIAlertController(
			title: securityVM.changeLockMethodAlertTitle,
			message: "",
			preferredStyle: .actionSheet
		)
		lockSelectMethodAlert.overrideUserInterfaceStyle = .light
		lockSelectMethodAlert
			.addAction(UIAlertAction(title: securityVM.alertCancelButtonTitle, style: .cancel, handler: nil))

<<<<<<< HEAD:Pino-iOS/Pino-iOS/Flows/Account/Setting/ViewController/SecurityViewController.swift
		for action in securityVM.lockMethods {
			let alertAction = UIAlertAction(title: action.title, style: .default, handler: { [weak self] _ in
				self?.securityVM.changeLockMethod(type: action.type)

=======
		for lockMethod in securityLockVM.lockMethods {
			let alertAction = UIAlertAction(title: lockMethod.title, style: .default, handler: { [weak self] _ in
				self?.securityLockVM.changeLockMethod(to: lockMethod)
>>>>>>> master:Pino-iOS/Pino-iOS/Flows/Account/Setting/ViewController/SecurityLockViewController.swift
			})
			lockSelectMethodAlert.addAction(alertAction)
		}

		present(lockSelectMethodAlert, animated: true)
	}
}
