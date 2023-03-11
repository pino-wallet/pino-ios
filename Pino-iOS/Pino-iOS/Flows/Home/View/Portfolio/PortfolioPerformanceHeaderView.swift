//
//  PortfolioPerformanceHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Charts
import Combine
import UIKit

class PortfolioPerformanceHeaderView: UICollectionReusableView {
	// MARK: Private Properties

	private let contentStackview = UIStackView()
	private let chartStackView = UIStackView()
	private let chartCardView = UIView()
	private let chartTitle = UILabel()
	private let assetsTitle = UILabel()
	private var lineChart: AssetLineChart!
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public static let headerReuseID = "portfolioPerformanceHeader"

	public var portfolioPerformanceVM: PortfolioPerformanceViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupContstraint()
			setupBindings()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		lineChart = AssetLineChart(chartVM: portfolioPerformanceVM.chartVM, dateFilterChanged: { dateFilter in
			self.portfolioPerformanceVM.updateChartData(by: dateFilter)
		})
		chartStackView.addArrangedSubview(chartTitle)
		chartStackView.addArrangedSubview(chartCardView)
		contentStackview.addArrangedSubview(chartStackView)
		contentStackview.addArrangedSubview(assetsTitle)
		chartCardView.addSubview(lineChart)
		addSubview(contentStackview)
	}

	private func setupStyle() {
		chartCardView.backgroundColor = .Pino.secondaryBackground

		chartTitle.text = "Total value"
		assetsTitle.text = "The share of assets"

		chartTitle.textColor = .Pino.label
		assetsTitle.textColor = .Pino.label

		chartTitle.font = .PinoStyle.semiboldTitle3
		assetsTitle.font = .PinoStyle.semiboldTitle3

		contentStackview.axis = .vertical
		chartStackView.axis = .vertical

		contentStackview.spacing = 32
		chartStackView.spacing = 14

		chartCardView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 24),
			.bottom(padding: 16)
		)
		chartCardView.pin(
			.fixedHeight(300)
		)
		lineChart.pin(
			.allEdges
		)
	}

	private func setupBindings() {
		portfolioPerformanceVM.$chartVM.sink { chart in
			self.lineChart.chartVM = chart!
		}.store(in: &cancellables)
	}
}
