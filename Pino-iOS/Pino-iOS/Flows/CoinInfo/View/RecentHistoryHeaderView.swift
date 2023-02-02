//
//  RecentHistoryHeaderView.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/30/23.
//

import UIKit

class ResentHistoryHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var titleLabel = UILabel()

	// MARK: - Public Properties

	public static let headerReuseID = "recentHistory"

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
		titleLabel.textColor = .Pino.label
		titleLabel.font = .PinoStyle.semiboldBody
	}

	private func setupConstraint() {
		titleLabel.pin(
			.bottom(padding: 5),
			.trailing(padding: 16),
			.leading(padding: 16)
		)
	}
}
