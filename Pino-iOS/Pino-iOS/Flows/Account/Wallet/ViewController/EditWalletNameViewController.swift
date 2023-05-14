//
//  EditWalletNameViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

import UIKit

class EditWalletNameViewController: UIViewController {
	// MARK: - Public Properties

	public var selectedWalletVM: WalletInfoViewModel
	public var walletsVM: WalletsViewModel

	// MARK: - Private Properties

	private var editWalletNameView: EditWalletNameView!
	private var editWalletNameVM: EditWalletNameViewModel!
	private var nameChanged: (String) -> Void

	// MARK: - Initializers

	init(selectedWalletVM: WalletInfoViewModel!, walletsVM: WalletsViewModel, nameChanged: @escaping (String) -> Void) {
		self.selectedWalletVM = selectedWalletVM
		self.walletsVM = walletsVM
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
		setupNotificationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupNotificationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle(editWalletNameVM.pageTitle)
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: editWalletNameVM.doneButtonName,
			style: .plain,
			target: self,
			action: #selector(saveWalletName)
		)
	}

	private func setupView() {
		editWalletNameView = EditWalletNameView(
			editWalletNameVM: editWalletNameVM,
			selectedWalletVM: selectedWalletVM,
			updateIsValidatedNameClosure: { [weak self] isWalletNameValidated in
				self?.navigationItem.rightBarButtonItem?.isEnabled = isWalletNameValidated
			}
		)

		editWalletNameView.endEditingViewclosure = { [weak self] in
			self?.view.endEditing(true)
		}

		editWalletNameView.doneButton.addTarget(self, action: #selector(saveWalletName), for: .touchUpInside)

		view = editWalletNameView
	}

	private func setupEditWalletNameVM() {
		editWalletNameVM = EditWalletNameViewModel(
			didValidatedWalletName: { [weak self] error in
				self?.showErrorMessage(error: error)
			},
			selectedWallet: selectedWalletVM,
			wallets: walletsVM.walletsList
		)
	}

	@objc
	private func saveWalletName() {
		nameChanged(editWalletNameView.walletNameTextFieldView.getText()!)
		navigationController?.popViewController(animated: true)
	}

	private func showErrorMessage(error: EditWalletNameViewModel.ValidateWalletNameErrorType) {
		switch error {
		case .isEmpty:
			navigationItem.rightBarButtonItem?.isEnabled = false
			editWalletNameView.doneButton.style = .deactive
			editWalletNameView.walletNameTextFieldView.style = .error
			editWalletNameView.walletNameTextFieldView.errorText = editWalletNameVM.walletNameIsEmptyError
		case .repeatedName:
			navigationItem.rightBarButtonItem?.isEnabled = false
			editWalletNameView.doneButton.style = .deactive
			editWalletNameView.walletNameTextFieldView.style = .error
			editWalletNameView.walletNameTextFieldView.errorText = editWalletNameVM.walletNameIsRepeatedError
		case .clear:
			navigationItem.rightBarButtonItem?.isEnabled = true
			editWalletNameView.doneButton.style = .active
			editWalletNameView.walletNameTextFieldView.style = .normal
			editWalletNameView.walletNameTextFieldView.errorText = ""
		}
	}
}
