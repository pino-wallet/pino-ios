//
//  InvestmentBoardFilterCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import UIKit

public class InvestmentBoardFilterCell: GroupCollectionViewCell {
	// MARK: Private Properties

	private let titleLabel = UILabel()
	private let detailStackView = UIStackView()
	private let descriptionLabel = UILabel()
	private let detailIcon = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "investmentBoardFilterCell"

	public var filterItemVM: InvestmentFilterItemViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		cardView.addSubview(titleLabel)
		cardView.addSubview(detailStackView)
		detailStackView.addArrangedSubview(descriptionLabel)
		detailStackView.addArrangedSubview(detailIcon)
	}

	private func setupStyle() {
		titleLabel.text = filterItemVM.title
		descriptionLabel.text = filterItemVM.description
		detailIcon.image = UIImage(named: "chevron_right")

		detailIcon.tintColor = .Pino.gray3

		titleLabel.font = .PinoStyle.mediumBody
		descriptionLabel.font = .PinoStyle.mediumBody

		titleLabel.textColor = .Pino.label
		descriptionLabel.textColor = .Pino.gray2

		detailStackView.axis = .horizontal
		detailStackView.alignment = .center
		detailStackView.spacing = 2
	}

	private func setupConstraint() {
		titleLabel.pin(
			.leading(padding: 16),
			.centerY
		)
		detailStackView.pin(
			.trailing(padding: 8),
			.centerY
		)
		detailIcon.pin(
			.fixedWidth(18),
			.fixedHeight(18)
		)

		NSLayoutConstraint.deactivate([separatorLeadingConstraint])
		separatorLine.pin(
			.leading(padding: 16)
		)
	}
}
