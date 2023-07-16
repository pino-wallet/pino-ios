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

    public var topPadding: Int = 16

	public static let viewReuseID = "ActivityHeaderViewID"

	// MARK: - Private Properties

	private let titleLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(titleLabel)
	}

	private func setupStyles() {
		titleLabel.font = .PinoStyle.mediumSubheadline
		titleLabel.text = titleText
		titleLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

		titleLabel.pin(.top(padding: CGFloat(topPadding)), .bottom(padding: 8), .horizontalEdges(padding: 16))
	}
}
