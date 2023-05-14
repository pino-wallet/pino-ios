//
//  ClearNavigationBar.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/10/23.
//

import UIKit

class ClearNavigationBar: UINavigationBar {
	// MARK: - Closures

	public var onDismiss: () -> Void = {}

	// MARK: - Private Properties

	private let mainView = UIView()
	private let dismissButton = UIButton()
	private let dismissButtonContainerView = UIView()

	// MARK: -  Initializers

	init() {
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupNavigationDismissButton()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		dismissButton.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)

		mainView.addSubview(dismissButton)

		addSubview(mainView)
	}

	private func setupStyles() {
		backgroundColor = .clear

		dismissButton.setImage(UIImage(named: "close"), for: .normal)
	}

	private func setupNavigationDismissButton() {}

	private func setupConstraints() {
		mainView.pin(.horizontalEdges(padding: 16), .verticalEdges(padding: 0), .fixedHeight(58))
		dismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
	}

	@objc
	private func onDismissTap() {
		onDismiss()
	}
}
