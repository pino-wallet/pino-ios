//
//  PositionHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import UIKit

class PositionHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var titleLabel = UILabel()

	// MARK: - Public Properties

	public static let headerReuseID = "positionHeader"

	public var title: String! {
		didSet {
			setupTitleView(title)
		}
	}

	// MARK: - Private Methods

	private func setupTitleView(_ title: String) {
		addSubview(titleLabel)

		backgroundColor = .Pino.background

		titleLabel.text = title
		titleLabel.textColor = .Pino.label
		titleLabel.font = .PinoStyle.semiboldBody

		titleLabel.pin(
			.bottom(padding: 5),
			.leading(padding: 16)
		)
	}
}
