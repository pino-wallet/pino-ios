//
//  InvestmentBoardFilterHeader.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import UIKit

class InvestmentBoardFilterHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let titleLabel = UILabel()
	private let clearFiltersButton = UIButton()

	// MARK: - Public Properties

	public static let viewReuseID = "InvestmentBoardFilterHeaderViewID"

	public var title: String! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public var clearFiltersDidTap: (() -> Void)!

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(titleLabel)
		contentStackview.addArrangedSubview(clearFiltersButton)

		clearFiltersButton.addAction(UIAction(handler: { _ in
			self.clearFiltersDidTap()
		}), for: .touchUpInside)
	}

	private func setupStyles() {
		titleLabel.text = title
		clearFiltersButton.setTitle("Clear filters", for: .normal)

		titleLabel.textColor = .Pino.label
		clearFiltersButton.setTitleColor(.Pino.secondaryLabel, for: .normal)

		titleLabel.font = .PinoStyle.mediumSubheadline
		clearFiltersButton.setConfiguraton(
			font: .PinoStyle.mediumSubheadline!,
			contentInset: NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
		)

		titleLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		contentStackview.pin(
			.leading(padding: 14),
			.trailing(padding: 10),
			.bottom(padding: 5)
		)
		clearFiltersButton.pin(
			.fixedWidth(90)
		)
	}
}
