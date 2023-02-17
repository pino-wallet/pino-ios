//
//  PinoLoading.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/12/23.
//

import UIKit

class PinoLoading: UIActivityIndicatorView {
	// MARK: - Public Properties

	public var size: Int {
		didSet {
			setupConstraints()
		}
	}

	public var indicatorColor: UIColor? {
		didSet {
			setupView()
		}
	}

	// MARK: - Initializers

	init(size: Int, indicatorColor: UIColor = UIColor.Pino.primary) {
		self.size = size
		self.indicatorColor = indicatorColor
		super.init(frame: .zero)
		setupView()
		setupConstraints()
		startAnimating()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		color = indicatorColor
	}

	private func setupConstraints() {
		pin(.fixedHeight(CGFloat(size)), .fixedWidth(CGFloat(size)))
	}
}
