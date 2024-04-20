//
//  CreateNewAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/20/24.
//

import UIKit

class CreateNewAccountViewController: UIViewController {
	// MARK: Private Properties

	private let createAccountVM: CreateNewAccountViewModel
	private var createAccountView: CreateNewAccountView!

	// MARK: Initializers

	init(accounts: [AccountInfoViewModel]) {
		self.createAccountVM = CreateNewAccountViewModel(accounts: accounts)
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
		createAccountView = CreateNewAccountView(
			avatarButtonDidTap: {
				self.openAvatarPage()
			},
			createButtonDidTap: {}
		)
		view = createAccountView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(createAccountVM.pageTitle)
	}

	private func openAvatarPage() {
		let avatarVM = AvatarViewModel(selectedAvatar: createAccountVM.accountAvatar.rawValue)
		let changeAvatarVC = ChangeAvatarViewController(avatarVM: avatarVM) { [weak self] avatarName in
			self?.createAccountVM.accountAvatar = Avatar(rawValue: avatarName)!
		}
		navigationController?.pushViewController(changeAvatarVC, animated: true)
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}
