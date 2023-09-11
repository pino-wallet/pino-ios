//
//  HealthScoreZoneDotView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/9/23.
//
import UIKit

class HealthScoreZoneDotView: UIView {
	// MARK: - Public Properties

	public var color: UIColor = .Pino.red {
		didSet {
			backgroundColor = color
		}
	}

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupStyles() {
		backgroundColor = color

		layer.cornerRadius = 6
	}

	private func setupConstraints() {
		heightAnchor.constraint(equalToConstant: 12).isActive = true
		widthAnchor.constraint(equalToConstant: 12).isActive = true
	}
}
