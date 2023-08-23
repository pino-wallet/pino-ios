//
//  InvestmentBoardFilterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Combine
import Foundation
import UIKit

class InvestmentBoardFilterView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let filtersCollectionView: InvestmentBoardFilterCollectionView
	private let filterButton = PinoButton(style: .active)
	private let applyFilters: () -> Void
	private let filterVM: InvestmentBoardFilterViewModel
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		filterVM: InvestmentBoardFilterViewModel,
		filterItemSelected: @escaping (InvestmentFilterItemViewModel) -> Void,
		clearFiltersDidTap: @escaping () -> Void,
		applyFilters: @escaping () -> Void
	) {
		self.filtersCollectionView = InvestmentBoardFilterCollectionView(
			filters: filterVM.filters,
			filterItemSelected: filterItemSelected,
			clearFiltersDidTap: clearFiltersDidTap
		)
		self.filterVM = filterVM
		self.applyFilters = applyFilters
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBinding()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		addSubview(filterButton)
		contentStackview.addArrangedSubview(filtersCollectionView)

		filterButton.addAction(UIAction(handler: { _ in
			self.applyFilters()
		}), for: .touchUpInside)
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

	private func setupBinding() {
		filterVM.$filters.compactMap { $0 }.sink { filters in
			self.filtersCollectionView.filters = filters
			self.filtersCollectionView.reloadData()
		}.store(in: &cancellables)
	}
}
