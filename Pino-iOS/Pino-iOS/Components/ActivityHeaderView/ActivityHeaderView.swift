//
//  ActivityHeaderView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/3/23.
//

import UIKit

class ActivityHeaderView: UICollectionReusableView {
	// MARK: - Public Properties

	public var titleText: String! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let viewReuseID = "ActivityHeaderViewID"

	// MARK: - Private Properties

	private let titleLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(titleLabel)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		titleLabel.font = .PinoStyle.mediumSubheadline
		titleLabel.text = titleText
		titleLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		titleLabel.pin(
			.top(padding: 16),
			.bottom(padding: 8),
			.horizontalEdges(padding: 16)
		)
	}
}
