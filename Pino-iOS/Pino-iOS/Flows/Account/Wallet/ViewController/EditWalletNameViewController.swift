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
	private let editWalletNameVM = EditWalletNameViewModel()

	// MARK: - Initializers

	init(selectedWalletVM: WalletInfoViewModel!, walletsVM: WalletsViewModel) {
		self.selectedWalletVM = selectedWalletVM
		self.walletsVM = walletsVM
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

	@objc
	private func saveWalletName() {
		let newWallet = WalletBuilder(walletInfo: selectedWalletVM)
		newWallet.setProfileName(editWalletNameView.walletNameTextFieldView.getText()!)
		selectedWalletVM = WalletInfoViewModel(walletInfoModel: newWallet.build())
		walletsVM.editWallet(newWallet: newWallet.build())
		navigationController?.popViewController(animated: true)
	}
}
