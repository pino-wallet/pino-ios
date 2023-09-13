//
//  ImportAccountsHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)

	// MARK: - Public Properties

	public static let viewReuseID = "ImportAcountsHeaderViewID"

	public var pageInfo: (title: String, description: String)! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(titleLabel)
		contentStackview.addArrangedSubview(descriptionLabel)
	}

	private func setupStyles() {
		titleLabel.text = pageInfo.title
		descriptionLabel.text = pageInfo.description

		contentStackview.axis = .vertical
		contentStackview.spacing = 18
	}

	private func setupConstraints() {
		contentStackview.pin(
			.top,
			.horizontalEdges
		)
	}
}
