//
//  PrivacyLockView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/17/23.
//

import Foundation
import UIKit

class PrivacyLockView: UIView {
	// MARK: - Private Properties

	private let pinoLogo = UIImage(named: "pino_logo_gradient")
	private lazy var pinoLogoImageView: UIImageView = {
		.init(image: pinoLogo)
	}()

	// MARK: Initializers

	// Initialize your UI components here
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .Pino.primary // or any color you prefer
		setupView()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(pinoLogoImageView)
	}

	private func setupContstraint() {
		pinoLogoImageView.pin(
			.centerX,
			.centerY
		)
	}

	private func setupBindings() {}
}
