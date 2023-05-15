//
//  NavigationBarDismissButton.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/15/23.
//

import UIKit

class NavigationBarDismissButton: UIView {
	// MARK: - Closures

	public var onDismiss: () -> Void

	// MARK: - Private Properties

	private let dismissButton = UIButton()

	// MARK: - Initializers

	init(onDismiss: @escaping () -> Void) {
		self.onDismiss = onDismiss
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		dismissButton.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)

		addSubview(dismissButton)
	}

	private func setupStyles() {
		dismissButton.setImage(UIImage(named: "close"), for: .normal)
	}

	private func setupConstraints() {
		dismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
	}

	@objc
	private func onDismissTap() {
		onDismiss()
	}
}
