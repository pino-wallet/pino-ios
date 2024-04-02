//
//  BorrowCommigSoonView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/24.
//

import UIKit

class BorrowComingSoonView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let emptyPageImageView = UIImageView()
	private let titleStackView = UIStackView()
	private let emptyPageTitle = UILabel()
	private let emptyPageDescription = PinoLabel(style: .description, text: nil)

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
		emptyPageImageView.image = UIImage(named: "borrow_coming_soon")
		emptyPageTitle.text = "Nearly here!"
		emptyPageDescription.text = #"The “Borrow” section is on its way. It should arrive sometime soon."#

		backgroundColor = .Pino.background
		emptyPageTitle.textColor = .Pino.label
		emptyPageDescription.textColor = .Pino.secondaryLabel

		emptyPageTitle.font = .PinoStyle.semiboldTitle2
		emptyPageDescription.font = .PinoStyle.mediumBody

		emptyPageDescription.numberOfLines = 0
		emptyPageDescription.textAlignment = .center

		contentStackview.axis = .vertical
		titleStackView.axis = .vertical

		contentStackview.alignment = .center
		titleStackView.alignment = .center

		contentStackview.spacing = 48
		titleStackView.spacing = 8
	}

	private func setupConstraint() {
        emptyPageTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        
		contentStackview.pin(
			.horizontalEdges(padding: 16)
		)

		NSLayoutConstraint.activate([
			NSLayoutConstraint(
				item: contentStackview,
				attribute: .centerY,
				relatedBy: .equal,
				toItem: self,
				attribute: .centerY,
				multiplier: 0.9,
				constant: 0
			),
		])
	}
}
