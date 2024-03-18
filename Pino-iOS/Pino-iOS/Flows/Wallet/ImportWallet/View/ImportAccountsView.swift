//
//  ImportAccountsView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Combine
import UIKit

class ImportAccountsView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let accountsCollectionView: ImportAccountsCollectionView
	private let importButton = PinoButton(style: .deactive)
	private var accountsVM: ImportAccountsViewModel
	private let importButtonDidTap: () -> Void
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		accountsVM: ImportAccountsViewModel,
		importButtonDidTap: @escaping () -> Void,
		findMoreAccountsDidTap: @escaping () -> Void
	) {
		self.accountsVM = accountsVM
		self.importButtonDidTap = importButtonDidTap
		self.accountsCollectionView = ImportAccountsCollectionView(
			accountsVM: accountsVM,
			findAccountsDidTap: findMoreAccountsDidTap
		)
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBinding()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Public Methods

	public func stopLoading() {
		importButton.style = .active
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(accountsCollectionView)
		contentStackView.addArrangedSubview(importButton)
		addSubview(contentStackView)

		importButton.addAction(UIAction(handler: { _ in
			self.importButton.style = .loading
			self.importButtonDidTap()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		importButton.title = "Continue"
		backgroundColor = .Pino.secondaryBackground
		contentStackView.axis = .vertical
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 26),
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
	}

	private func setupBinding() {
		accountsVM.$accounts.compactMap { $0 }.sink { accounts in
			self.accountsCollectionView.accounts = accounts
			self.accountsCollectionView.reloadData()
			if !accounts.filter({ $0.isSelected }).isEmpty {
				self.importButton.style = .active
			} else {
				self.importButton.style = .deactive
			}
		}.store(in: &cancellables)
	}
}
