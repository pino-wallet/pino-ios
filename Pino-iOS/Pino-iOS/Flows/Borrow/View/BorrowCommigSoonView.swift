//
//  BorrowCommigSoonView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/24.
//

import UIKit

class BorrowCommingSoonView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let emptyPageImageView = UIImageView()
	private let titleStackView = UIStackView()
	private let emptyPageTitle = UILabel()
	private let emptyPageDescription = UILabel()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(emptyPageImageView)
		contentStackview.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(emptyPageTitle)
		titleStackView.addArrangedSubview(emptyPageDescription)
	}

	private func setupStyle() {
		emptyPageImageView.image = UIImage(named: "")
		emptyPageTitle.text = ""
		emptyPageDescription.text = ""

		backgroundColor = .Pino.background
		emptyPageTitle.textColor = .Pino.label
		emptyPageDescription.textColor = .Pino.secondaryLabel

		emptyPageTitle.font = .PinoStyle.semiboldTitle2
		emptyPageDescription.font = .PinoStyle.mediumBody

		contentStackview.axis = .vertical
		titleStackView.axis = .vertical

		contentStackview.alignment = .center
		titleStackView.alignment = .center

		contentStackview.spacing = 24
		titleStackView.spacing = -5
	}

	private func setupConstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.centerY
		)
	}
}
