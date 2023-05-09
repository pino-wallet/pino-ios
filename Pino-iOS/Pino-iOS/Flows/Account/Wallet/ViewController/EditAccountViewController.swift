//
//  EditAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import Combine
import UIKit

class EditAccountViewController: UIViewController {
	// MARK: Private Properties

	private var selectedWallet: WalletInfoViewModel

	private let walletsVM: WalletsViewModel

	private let editAccountVM = EditAccountViewModel()
	private var cancellables = Set<AnyCancellable>()

	private var editAccountView: EditAccountView!

	// MARK: Initializers

	init(walletsVM: WalletsViewModel, selectedWallet: WalletInfoViewModel) {
		self.walletsVM = walletsVM
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
		editAccountView = EditAccountView(
			editAccountVM: editAccountVM,
			selectedWalletVM: selectedWallet,
			openAvatarPage: { [weak self] in
				self?.openAvatarPage()
			},
			openRemoveAccount: { [weak self] in
				self?.openRemoveAccountPage()
			},
			openRevealPrivateKey: { [weak self] in
				self?.openRevealPrivateKey()
			},
			openEditWalletNameClosure: { [weak self] in
				self?.openEditWalletName()
			}
		)
		view = editAccountView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle(editAccountVM.pageTitle)
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: editAccountVM.doneButtonText,
			style: .plain,
			target: self,
			action: #selector(saveChanges)
		)
	}

	@objc
	private func saveChanges() {
		dismiss(animated: true)
	}

	private func openAvatarPage() {
		let avatarVM = AvatarViewModel(selectedAvatar: selectedWallet.profileImage)
		let changeAvatarVC = ChangeAvatarViewController(avatarVM: avatarVM) { [weak self] avatarName in
			if self?.selectedWallet.profileImage != avatarName {
				let newWallet = WalletBuilder(walletInfo: self!.selectedWallet)
				newWallet.setProfileImage(avatarName)
				newWallet.setProfileColor(avatarName)
				self?.walletsVM.editWallet(newWallet: newWallet.build())
			}
		}
		navigationController?.pushViewController(changeAvatarVC, animated: true)
	}

	private func openRemoveAccountPage() {
		let navigationVC = UINavigationController()
		let removeAccountVC = RemoveAccountViewController()
		navigationVC.viewControllers = [removeAccountVC]
		present(navigationVC, animated: true)
		removeAccountVC.walletIsDeleted = {
			self.removeWallet()
		}
	}

	private func removeWallet() {
		walletsVM.removeWallet(selectedWallet)
		navigationController!.popViewController(animated: true)
	}

	private func openRevealPrivateKey() {
		let revaelPrivateKeyVC = RevealPrivateKeyViewController()
		navigationController?.pushViewController(revaelPrivateKeyVC, animated: true)
	}

	private func openEditWalletName() {
		let editWalletNameVC = EditWalletNameViewController(selectedWalletVM: selectedWallet, walletsVM: walletsVM)
		navigationController?.pushViewController(editWalletNameVC, animated: true)
	}
}
