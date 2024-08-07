//
//  EditAccountNameViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

import UIKit

class EditAccountNameViewController: UIViewController {
	// MARK: - Public Properties

	public var selectedAccountVM: AccountInfoViewModel
	public var accountsVM: AccountsViewModel

	// MARK: - Private Properties

	private let hapticManager = HapticManager()
	private var editAccountNameView: EditAccountNameView!
	private var editAccountNameVM: EditAccountNameViewModel!
	private var nameChanged: (String) -> Void

	// MARK: - Initializers

	init(
		selectedAccountVM: AccountInfoViewModel!,
		accountsVM: AccountsViewModel,
		nameChanged: @escaping (String) -> Void
	) {
		self.selectedAccountVM = selectedAccountVM
		self.accountsVM = accountsVM
		self.nameChanged = nameChanged
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
		setupEditAccountNameVM()
		setupNotificationBar()
		setupView()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			hapticManager.run(type: .selectionChanged)
		}
	}

	// MARK: - Private Methods

	private func setupNotificationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle(editAccountNameVM.pageTitle)
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: editAccountNameVM.doneButtonName,
			style: .plain,
			target: self,
			action: #selector(saveAccountName)
		)
	}

	private func setupView() {
		editAccountNameView = EditAccountNameView(
			editAccountNameVM: editAccountNameVM,
			selectedAccountVM: selectedAccountVM
		)

		editAccountNameView.endEditingViewclosure = { [weak self] in
			self?.view.endEditing(true)
		}

		editAccountNameView.doneButton.addTarget(self, action: #selector(saveAccountName), for: .touchUpInside)

		view = editAccountNameView
	}

	private func setupEditAccountNameVM() {
		editAccountNameVM = EditAccountNameViewModel(
			didValidatedAccountName: { [weak self] validationStatus in
				self?.showErrorMessage(validationStatus: validationStatus)
			},
			selectedAccount: selectedAccountVM,
			accounts: accountsVM.accountsList
		)
	}

	@objc
	private func saveAccountName() {
		hapticManager.run(type: .selectionChanged)
		nameChanged(editAccountNameView.walletNameTextFieldView.getText()!)
		navigationController?.popViewController(animated: true)
	}

	private func showErrorMessage(validationStatus: AccountNameValidationStatus) {
		switch validationStatus {
		case .isEmpty:
			navigationItem.rightBarButtonItem?.isEnabled = false
			editAccountNameView.doneButton.style = .deactive
			editAccountNameView.doneButton.title = editAccountNameVM.accountNameIsEmptyError
			editAccountNameView.walletNameTextFieldView.style = .error
		case .duplicateName:
			navigationItem.rightBarButtonItem?.isEnabled = false
			editAccountNameView.doneButton.style = .deactive
			editAccountNameView.doneButton.title = editAccountNameVM.accountNameIsRepeatedError
			editAccountNameView.walletNameTextFieldView.style = .error
		case .isValid:
			navigationItem.rightBarButtonItem?.isEnabled = true
			editAccountNameView.doneButton.style = .active
			editAccountNameView.doneButton.title = editAccountNameVM.doneButtonName
			editAccountNameView.walletNameTextFieldView.style = .normal
		}
	}
}
