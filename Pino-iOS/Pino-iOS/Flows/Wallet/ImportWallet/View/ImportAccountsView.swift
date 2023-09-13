//
//  ImportAccountsView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let accountsCollectionView: ImportAccountsCollectionView
	private let importButton = PinoButton(style: .deactive)
	private var accountsVM: ImportAccountsViewModel
	private let importButtonDidTap: () -> Void

	// MARK: - Initializers

	init(accountsVM: ImportAccountsViewModel, importButtonDidTap: @escaping () -> Void) {
		self.accountsVM = accountsVM
		self.importButtonDidTap = importButtonDidTap
		self.accountsCollectionView = ImportAccountsCollectionView(accountsVM: accountsVM)
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
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

	// MARK: - Private Methods

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
}
