//
//  RecentAddressHeaderView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import UIKit

class SuggestedAddressHeaderView: UICollectionReusableView {
	// MARK: - Public Properties

	public var title: String! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let viewReuseID = "RecentAddressHeaderViewID"

	// MARK: - Private Properties

	private let titleLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(titleLabel)
	}

	private func setupStyles() {
		titleLabel.font = .PinoStyle.semiboldSubheadline
		titleLabel.textColor = .Pino.primary
		titleLabel.text = title
		titleLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

		titleLabel.pin(.horizontalEdges(padding: 14), .bottom(padding: 16))
	}
}
