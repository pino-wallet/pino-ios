//
//  CreateNewAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/20/24.
//

import UIKit

class CreateNewAccountView: UIView {
	// MARK: Private Properties

	private let avatarButtonDidTap: () -> Void
	private let createButtonDidTap: () -> Void

	// MARK: - Initializers

	init(
		avatarButtonDidTap: @escaping () -> Void,
		createButtonDidTap: @escaping () -> Void
	) {
		self.avatarButtonDidTap = avatarButtonDidTap
		self.createButtonDidTap = createButtonDidTap
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
