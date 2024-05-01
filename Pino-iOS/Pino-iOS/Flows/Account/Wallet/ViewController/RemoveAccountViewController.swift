//
//  RemoveAccountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/25/23.
//

import UIKit

class RemoveAccountViewController: UIViewController {
	// MARK: - Private Properties

	private var removeAccountVM: RemoveAccountViewModel!
	private let dismissButton = UIButton()
	private let dismissButtonContainerView = UIView()
	private let hapticManager = HapticManager()

	init(removeAccountVM: RemoveAccountViewModel, walletIsDeleted: @escaping (() -> Void)) {
		self.removeAccountVM = removeAccountVM
		self.walletIsDeleted = walletIsDeleted
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

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
		}, removeAccountVM: removeAccountVM, dismissPage: { [weak self] in
			self?.dismiss(animated: true)
		})
		view = removeAccountView
	}

	private func presentConfirmRemoveAccountAlert() {
		let confirmRemoveAccountAlert = AlertHelper.alertController(
			title: removeAccountVM.confirmActionSheetTitle,
			message: removeAccountVM.confirmActionSheetDescriptionText,
			actions: [
				.cancel(),
				.remove(handler: { _ in
					self.hapticManager.run(type: .lightImpact)
					self.dismiss(animated: true) {
						self.walletIsDeleted()
					}
				}),
			]
		)

		present(confirmRemoveAccountAlert, animated: true)
	}
}
