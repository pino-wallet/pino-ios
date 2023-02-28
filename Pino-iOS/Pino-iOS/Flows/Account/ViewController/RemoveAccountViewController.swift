//
//  RemoveAccountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/25/23.
//

import UIKit

class RemoveAccountViewController: UIViewController {
	// MARK: - Private Properties

	private let removeAccountVM = RemoveAccountViewModel()
	private let dismissButton = UIButton()
	private let dismissButtonContainerView = UIView()

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
		let removeAccountView = RemoveAccountView(presentConfirmActionsheetClosure: { [weak self] in
			self?.presentConfirmRemoveAccountAlert()
		}, removeAccountVM: removeAccountVM)
		view = removeAccountView
	}

	private func setupNavigationBar() {
		dismissButton.setImage(UIImage(named: removeAccountVM.navigationDismissButtonIconName), for: .normal)
		dismissButtonContainerView.frame = CGRectMake(0, 0, 30, 46)
		dismissButtonContainerView.addSubview(dismissButton)
		dismissButton.frame = CGRectMake(0, 14, 30, 30)
		dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dismissButtonContainerView)
	}

	private func presentConfirmRemoveAccountAlert() {
		let confirmRemoveAccountAlert = UIAlertController(
			title: "Are you sure you want to remove your account?",
			message: removeAccountVM.confirmActionSheetDescriptionText,
			preferredStyle: .alert
		)
		confirmRemoveAccountAlert
			.addAction(UIAlertAction(title: removeAccountVM.dismissActionsheetButtonTitle, style: .cancel))
		#warning("this handler is for testing and should be changed")
		confirmRemoveAccountAlert.addAction(UIAlertAction(
			title: removeAccountVM.confirmActionSheetButtonTitle,
			style: .destructive,
			handler: { _ in print("removed!") }
		))
		present(confirmRemoveAccountAlert, animated: true)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
