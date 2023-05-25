//
//  EditAccountView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

import Combine
import UIKit

class EditAccountView: UIView {
	// MARK: - Closures

	public var openAvatarPage: () -> Void
	public var openRevealPrivateKey: () -> Void
	public var openRemoveAccount: () -> Void
	public let openEditAccountNameClosure: () -> Void

	// MARK: - Public Properties

	public var editAccountVM: EditAccountViewModel

	// MARK: - Initializers

	init(
		editAccountVM: EditAccountViewModel,
		openAvatarPage: @escaping () -> Void,
		openRemoveAccount: @escaping () -> Void,
		openRevealPrivateKey: @escaping () -> Void,
		openEditAccountNameClosure: @escaping () -> Void
	) {
		self.openAvatarPage = openAvatarPage
		self.openRevealPrivateKey = openRevealPrivateKey
		self.editAccountVM = editAccountVM
		self.openRemoveAccount = openRemoveAccount
		self.openEditAccountNameClosure = openEditAccountNameClosure
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBinding()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private var editAccountCollectionView: EditAccountCollectionView!
	private let removeAccountButton = PinoButton(style: .remove, title: "")
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Private Methods

	private func setupView() {
		editAccountCollectionView = EditAccountCollectionView(
			editAccountVM: editAccountVM,
			newAvatarTappedClosure: { [weak self] in
				self?.openAvatarPage()
			},
			openRevealPrivateKeyClosure: { [weak self] in
				self?.openRevealPrivateKey()
			},
			openEditAccountNameClosure: { [weak self] in
				self?.openEditAccountNameClosure()
			}
		)

		removeAccountButton.addTarget(self, action: #selector(openRemoveAccountPage), for: .touchUpInside)

		addSubview(editAccountCollectionView)
		addSubview(removeAccountButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		removeAccountButton.setTitle(editAccountVM.removeAccountButtonTitle, for: .normal)
	}

	private func setupConstraints() {
		editAccountCollectionView.pin(.horizontalEdges(padding: 0), .top(padding: 0), .bottom(padding: 100))
		removeAccountButton.pin(.horizontalEdges(padding: 16), .bottom(padding: 32))
	}

	private func setupBinding() {
		editAccountVM.$selectedAccount.sink { [weak self] selectedAccount in
			self?.editAccountCollectionView.reloadData()
		}.store(in: &cancellables)

		editAccountVM.$isLastAccount.sink { isLastAccount in
			if isLastAccount {
				self.removeAccountButton.isHidden = true
			} else {
				self.removeAccountButton.isHidden = false
			}
		}.store(in: &cancellables)
	}

	@objc
	private func openRemoveAccountPage() {
		openRemoveAccount()
	}
}

extension PinoButton.Style {
	fileprivate static var remove: PinoButton.Style {
		PinoButton.Style(titleColor: .Pino.red, backgroundColor: .Pino.white, borderColor: .Pino.white)
	}
}
