//
//  ChangeAvatarViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/15/23.
//

import UIKit

class ChangeAvatarViewController: UIViewController {
	// MARK: Private Properties

	private var avatarVM: AvatarViewModel
	private var avatarChanged: (String) -> Void

	// MARK: Initializers

	init(avatarVM: AvatarViewModel, avatarChanged: @escaping (String) -> Void) {
		self.avatarVM = avatarVM
		self.avatarChanged = avatarChanged
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
		view = AvatarCollectionView(
			avatarVM: avatarVM,
			avatarSelected: { selectedAvatar in
				self.avatarVM.selectedAvatar = selectedAvatar
			}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Change avatar")
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(saveChanges)
		)
		let textAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.white,
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldBody!,
		]
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
	}

	@objc
	private func saveChanges() {
		avatarChanged(avatarVM.selectedAvatar)
		navigationController?.popViewController(animated: true)
	}
}
