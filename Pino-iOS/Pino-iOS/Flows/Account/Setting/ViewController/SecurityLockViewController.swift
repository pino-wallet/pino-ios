//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class SecurityLockViewController: UIViewController {
	// MARK: - Private Properties

	private let securityLockVM = SecurityLockViewModel()

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
		setNavigationTitle(securityLockVM.pageTitle)
	}

	private func setupView() {
		view = AuthenticationOptionsCollectionView(
			securityLockVM: securityLockVM,
			openSelectLockMethodAlertClosure: { [weak self] in
				self?.openLockSelectMethodAlert()
			}
		)
	}

	private func openLockSelectMethodAlert() {
		let lockSelectMethodAlert = UIAlertController(
			title: securityLockVM.changeLockMethodAlertTitle,
			message: "",
			preferredStyle: .actionSheet
		)
		lockSelectMethodAlert.overrideUserInterfaceStyle = .light
		lockSelectMethodAlert
			.addAction(UIAlertAction(title: securityLockVM.alertCancelButtonTitle, style: .cancel, handler: nil))

		for action in securityLockVM.lockMethods {
			let alertAction = UIAlertAction(title: action.title, style: .default, handler: { [weak self] _ in
				self?.securityLockVM.changeLockMethod(type: action.type)

			})
			lockSelectMethodAlert.addAction(alertAction)
		}

		present(lockSelectMethodAlert, animated: true)
	}
}
