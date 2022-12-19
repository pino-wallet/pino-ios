//
//  ToastView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

class PinoToastView: UIView {
	// MARK: - Private Properties

	private let copyLabel = UILabel()

	// MARK: - Initializers

	init(message: String) {
		super.init(frame: .zero)
		setupView()
		setupStyle(message: message)
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func showToast() {
		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.alpha = 1
		}

		UIView.animate(withDuration: 0.5, delay: 2) { [weak self] in
			self?.alpha = 0
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(copyLabel)
	}

	private func setupStyle(message: String) {
		copyLabel.text = message

		copyLabel.textColor = .Pino.white
		copyLabel.font = .PinoStyle.semiboldFootnote

		backgroundColor = .Pino.primary
		layer.cornerRadius = 14

		alpha = 0
	}

	private func setupConstraint() {
		pin(
			.fixedHeight(28)
		)
		copyLabel.pin(
			.centerY,
			.horizontalEdges(padding: 12)
		)
	}
}
