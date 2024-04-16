//
//  ImportNewAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/3/24.
//

import UIKit

class ImportNewAccountViewController: UIViewController {
	// MARK: - PublicProperties

	public var importAccountView: ImportNewAccountView!
	public var importAccountVM: ImportNewAccountViewModel
	public var newAccountDidImport: ((_ privateKey: String, _ avatar: Avatar, _ accountName: String) -> Void)!

	// MARK: Initializers

	init(accounts: [AccountInfoViewModel]) {
		self.importAccountVM = ImportNewAccountViewModel(accounts: accounts)
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
		setupPrimaryColorNavigationBar()
		setNavigationTitle(importAccountVM.pageTitle)
	}

	// MARK: - Private Methods

	private func setupView() {
		importAccountView = ImportNewAccountView(
			importAccountVM: importAccountVM,
			importButtonDidTap: {
				self.importWallet()
			},
			changeAvatarDidTap: {
				self.openAvatarPage()
			}
		)
		view = importAccountView
	}

	private func importWallet() {
		guard importAccountVM.isAccountNameValid() else { return }
		importAccountView.showLoading()
		let privateKey = importAccountView.textViewText
		importAccountVM.validateWalletAccount(
			privateKey: privateKey,
			onSuccess: { [weak self] in
				guard let self else { return }
				newAccountDidImport(privateKey, importAccountVM.accountAvatar, importAccountVM.accountName)
			},
			onFailure: { validationError in
				self.showValidationError(validationError)
			}
		)
	}

	private func openAvatarPage() {
		let avatarVM = AvatarViewModel(selectedAvatar: importAccountVM.accountAvatar.rawValue)
		let changeAvatarVC = ChangeAvatarViewController(avatarVM: avatarVM) { [weak self] avatarName in
			self?.importAccountVM.accountAvatar = Avatar(rawValue: avatarName)!
		}
		navigationController?.pushViewController(changeAvatarVC, animated: true)
	}

	// MARK: - Public Methods

	public func showValidationError(_ error: Error) {
		importAccountVM.privateKeyValidationStatus = .invalidAccount
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}
