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
	public let openEditWalletNameClosure: () -> Void

	// MARK: - Public Properties

	public var editAccountVM: EditAccountViewModel
	@Published
	public var selectedWalletVM: WalletInfoViewModel

	// MARK: - Initializers

	init(
		editAccountVM: EditAccountViewModel,
		selectedWalletVM: WalletInfoViewModel,
		openAvatarPage: @escaping () -> Void,
		openRemoveAccount: @escaping () -> Void,
		openRevealPrivateKey: @escaping () -> Void,
		openEditWalletNameClosure: @escaping () -> Void
	) {
		self.openAvatarPage = openAvatarPage
		self.openRevealPrivateKey = openRevealPrivateKey
		self.editAccountVM = editAccountVM
		self.selectedWalletVM = selectedWalletVM
		self.openRemoveAccount = openRemoveAccount
		self.openEditWalletNameClosure = openEditWalletNameClosure
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
			walletVM: selectedWalletVM,
			newAvatarTappedClosure: { [weak self] in
				self?.openAvatarPage()
			},
			openRevealPrivateKeyClosure: { [weak self] in
				self?.openRevealPrivateKey()
			},
			openEditWalletNameClosure: { [weak self] in
				self?.openEditWalletNameClosure()
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
		$selectedWalletVM.sink { [weak self] selectedWallet in
			self?.editAccountCollectionView.selectedWalletVM = selectedWallet
			self?.editAccountCollectionView.reloadData()
		}.store(in: &cancellables)

		editAccountVM.$isLastWallet.sink { isLastWallet in
			if isLastWallet {
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
