//
//  InvestmentBoardFilterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation
import UIKit

class InvestmentBoardFilterView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let filtersCollectionView: InvestmentBoardFilterCollectionView
	private let filterButton = PinoButton(style: .active)

	// MARK: - Initializers

	init(
		filterVM: InvestmentBoardFilterViewModel,
		filterItemSelected: @escaping (InvestmentFilterItemViewModel) -> Void,
		clearFiltersDidTap: @escaping () -> Void
	) {
		self.filtersCollectionView = InvestmentBoardFilterCollectionView(
			filterVM: filterVM,
			filterItemSelected: filterItemSelected,
			clearFiltersDidTap: clearFiltersDidTap
		)
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		addSubview(filterButton)
		contentStackview.addArrangedSubview(filtersCollectionView)
	}

	private func setupStyle() {
		filterButton.title = "Filter"
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges,
			.verticalEdges
		)
		filterButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
	}
}
