//
//  EditAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import UIKit

class EditAccountViewController: UIViewController {
	// MARK: Private Properties

	private let walletVM: WalletsViewModel
	private let selectedWallet: WalletInfoViewModel
	private var editAccountView: EditAccountView!

	// MARK: Initializers

	init(walletVM: WalletsViewModel, selectedWallet: WalletInfoViewModel) {
		self.walletVM = walletVM
		self.selectedWallet = selectedWallet
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

	// MARK: - Private Methods

	private func setupView() {
		editAccountView = EditAccountView(walletVM: selectedWallet, newAvatarTapped: { [weak self] in
			self?.openAvatarPage()
		}, navigateToRemoveAccountPageClosure: { [weak self] in
			self?.openRemoveAccountPage()
		})
		view = editAccountView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Edit account")
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(saveChanges)
		)
	}

	@objc
	private func saveChanges() {
		if let newName = editAccountView.walletNameTextFieldView.getText() {
			let newAvatar = editAccountView.newAvatar
			let builder = WalletBuilder(walletInfo: selectedWallet)
			if selectedWallet.name != newName {
				builder.setProfileName(newName)
			}
			if selectedWallet.profileImage != newAvatar {
				builder.setProfileImage(newAvatar)
			}
			if selectedWallet.profileColor != newAvatar {
				builder.setProfileColor(newAvatar)
			}
			walletVM.editWallet(newWallet: builder.build())
			navigationController!.popViewController(animated: true)
		} else {
			editAccountView.walletNameTextFieldView.style = .error
		}
	}

	private func openAvatarPage() {
		let avatarVM = AvatarViewModel(selectedAvatar: selectedWallet.profileImage)
		let changeAvatarVC = ChangeAvatarViewController(avatarVM: avatarVM) { avatarName in
			self.editAccountView.newAvatar = avatarName
		}
		navigationController?.pushViewController(changeAvatarVC, animated: true)
	}

	private func openRemoveAccountPage() {
		let navigationVC = UINavigationController()
		let removeAccountVC = RemoveAccountViewController()
		navigationVC.viewControllers = [removeAccountVC]
		present(navigationVC, animated: true)
	}
}
