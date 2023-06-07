//
//  Card.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/7/23.
//

import UIKit

class PinoContainerCard: UIView {
	// MARK: - Public Properties

	public var cornerRadius: CGFloat

	// MARK: - Initializers

	init(cornerRadius: CGFloat = 12) {
		self.cornerRadius = cornerRadius
		super.init(frame: .zero)

		setupStyles()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		layer.cornerRadius = cornerRadius
	}
}
