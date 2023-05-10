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

	// MARK: - Public Properties

	public var walletIsDeleted: (() -> Void)!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		let removeAccountView = RemoveAccountView(presentConfirmActionsheetClosure: { [weak self] in
			self?.presentConfirmRemoveAccountAlert()
		}, removeAccountVM: removeAccountVM)
		removeAccountView.dismissPage = { [weak self] in
			self?.dismiss(animated: true)
		}
		view = removeAccountView
	}

	private func presentConfirmRemoveAccountAlert() {
		let confirmRemoveAccountAlert = AlertHelper.alertController(
			title: removeAccountVM.confirmActionSheetTitle,
			message: removeAccountVM.confirmActionSheetDescriptionText,
			actions: [
				.cancel(),
				.delete(handler: { _ in
					self.dismiss(animated: true)
					self.walletIsDeleted()
				}),
			]
		)

		present(confirmRemoveAccountAlert, animated: true)
	}
}
