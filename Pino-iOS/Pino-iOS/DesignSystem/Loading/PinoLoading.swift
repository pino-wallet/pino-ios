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
			setupFrame()
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
		setupFrame()
		startAnimating()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		color = indicatorColor
	}

	private func setupFrame() {
		let sizeCGFloat = CGFloat(size)
		frame = CGRectMake(0, 0, sizeCGFloat, sizeCGFloat)
	}
}
