//
//  InvestmentBoardHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import UIKit

class AssetsBoardHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let titleLabel = UILabel()
	private let filterButton = UIButton()

	// MARK: - Public Properties

	public static let viewReuseID = "InvestmentBoardHeaderViewID"

	public var title: String! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public var hasFilter = false {
		didSet {
			if hasFilter {
				showFilterButton()
			} else {
				hideFilterButton()
			}
		}
	}

	public var filterDidTap: (() -> Void)?

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(titleLabel)
		contentStackview.addArrangedSubview(filterButton)

		filterButton.addAction(UIAction(handler: { _ in
			if let filterDidTap = self.filterDidTap {
				filterDidTap()
			}
		}), for: .touchUpInside)
	}

	private func setupStyles() {
		titleLabel.text = title
		titleLabel.font = .PinoStyle.mediumSubheadline
		titleLabel.textColor = .Pino.label
		titleLabel.numberOfLines = 0

		filterButton.setTitle("Filter", for: .normal)
		filterButton.setImage(UIImage(named: "board_filter"), for: .normal)
		filterButton.setTitleColor(.Pino.secondaryLabel, for: .normal)
		filterButton.setConfiguraton(
			font: .PinoStyle.mediumSubheadline!,
			imagePadding: 2,
			contentInset: NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5),
			imagePlacement: .trailing
		)
	}

	private func setupConstraints() {
		contentStackview.pin(
			.leading(padding: 14),
			.trailing(padding: 10),
			.bottom(padding: 5)
		)
		filterButton.pin(
			.fixedWidth(65)
		)
	}

	private func showFilterButton() {
		filterButton.isHiddenInStackView = false
	}

	private func hideFilterButton() {
		filterButton.isHiddenInStackView = true
	}
}
