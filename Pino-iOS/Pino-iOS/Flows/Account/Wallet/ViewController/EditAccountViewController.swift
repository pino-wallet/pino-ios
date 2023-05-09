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

	private let walletsVM: WalletsViewModel
	private let editAccountVM: EditAccountViewModel
	private var cancellables = Set<AnyCancellable>()

	private var editAccountView: EditAccountView!

	// MARK: Initializers

	init(walletsVM: WalletsViewModel, editAccountVM: EditAccountViewModel) {
		self.walletsVM = walletsVM
		self.editAccountVM = editAccountVM
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
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		editAccountView = EditAccountView(
			editAccountVM: editAccountVM,
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

	private func setupBindings() {
		walletsVM.$walletsList.sink { wallets in
			guard let wallets else { return }
			if wallets.count > 1 {
				self.editAccountVM.isLastWallet = false
			} else {
				self.editAccountVM.isLastWallet = true
			}
		}.store(in: &cancellables)
	}

	@objc
	private func saveChanges() {
		dismiss(animated: true)
	}

	private func openAvatarPage() {
		let avatarVM = AvatarViewModel(selectedAvatar: editAccountVM.selectedWallet.profileImage)
		let changeAvatarVC = ChangeAvatarViewController(avatarVM: avatarVM) { [weak self] avatarName in
			self?.editWalletAvatar(newAvatar: avatarName)
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
		walletsVM.removeWallet(editAccountVM.selectedWallet)
		navigationController!.popViewController(animated: true)
	}

	private func openRevealPrivateKey() {
		let revaelPrivateKeyVC = RevealPrivateKeyViewController()
		navigationController?.pushViewController(revaelPrivateKeyVC, animated: true)
	}

	private func openEditWalletName() {
		let editWalletNameVC = EditWalletNameViewController(
			selectedWalletVM: editAccountVM.selectedWallet,
			walletsVM: walletsVM
		) { [weak self] walletName in
			self?.editWalletName(newName: walletName)
		}
		navigationController?.pushViewController(editWalletNameVC, animated: true)
	}

	private func editWalletName(newName: String) {
		let edittedWallet = walletsVM.editWallet(wallet: editAccountVM.selectedWallet, newName: newName)
		editAccountVM.selectedWallet = edittedWallet
	}

	private func editWalletAvatar(newAvatar: String) {
		let edittedWallet = walletsVM.editWallet(wallet: editAccountVM.selectedWallet, newAvatar: newAvatar)
		editAccountVM.selectedWallet = edittedWallet
	}
}
