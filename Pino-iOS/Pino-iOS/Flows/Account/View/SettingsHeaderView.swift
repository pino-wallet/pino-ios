//
//  SettingsHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import UIKit

class SettingsHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var titleLabel = UILabel()

	// MARK: - Public Properties

	public static let headerReuseID = "settingsHeader"

	public var title: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(titleLabel)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background

		titleLabel.text = title
		titleLabel.textColor = .Pino.secondaryLabel
		titleLabel.font = .PinoStyle.mediumSubheadline
	}

	private func setupConstraint() {
		titleLabel.pin(
			.bottom(padding: 12),
			.horizontalEdges(padding: 16)
		)
	}
}
