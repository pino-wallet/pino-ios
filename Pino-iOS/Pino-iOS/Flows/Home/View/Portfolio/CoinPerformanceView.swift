//
//  CoinPerformanceView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Charts
import Combine
import UIKit

class CoinPerformanceView: UIView {
	// MARK: Private Properties

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let contentStackview = UIStackView()
	private let moreInfoStackView = UIStackView()
	private let chartCardView = UIView()
	private let infoCardView = UIView()
	private let infoStackView = UIStackView()
	private let moreInfoTitle = UILabel()
	private var lineChart: LineChart!
	private let coinPerformanceVM: CoinPerformanceViewModel

	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(coinPerformanceVM: CoinPerformanceViewModel) {
		self.coinPerformanceVM = coinPerformanceVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		lineChart = LineChart(chartVM: coinPerformanceVM.chartVM, dateFilterChanged: { dateFilter in
			self.coinPerformanceVM.updateChartData(by: dateFilter)
		})
		contentStackview.addArrangedSubview(chartCardView)
		contentStackview.addArrangedSubview(moreInfoStackView)
		moreInfoStackView.addArrangedSubview(moreInfoTitle)
		moreInfoStackView.addArrangedSubview(infoCardView)
		contentView.addSubview(contentStackview)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		infoCardView.addSubview(infoStackView)
		chartCardView.addSubview(lineChart)

		infoStackView.addArrangedSubview(CoinInfoItem(item: coinPerformanceVM.coinInfoVM.netProfit))
		infoStackView.addArrangedSubview(CoinInfoItem(item: coinPerformanceVM.coinInfoVM.allTimeHigh))
		infoStackView.addArrangedSubview(CoinInfoItem(item: coinPerformanceVM.coinInfoVM.allTimeLow))
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		chartCardView.backgroundColor = .Pino.secondaryBackground
		infoCardView.backgroundColor = .Pino.secondaryBackground
		contentView.backgroundColor = .Pino.clear
		scrollView.backgroundColor = .Pino.clear

		contentStackview.axis = .vertical
		moreInfoStackView.axis = .vertical
		infoStackView.axis = .vertical

		contentStackview.spacing = 32
		moreInfoStackView.spacing = 8

		infoCardView.layer.cornerRadius = 12
		chartCardView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		scrollView.pin(
			.allEdges()
		)
		contentView.pin(
			.allEdges,
			.relative(.width, 0, to: self, .width)
		)
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 24)
		)
		chartCardView.pin(
			.fixedHeight(423)
		)
		infoStackView.pin(
			.verticalEdges(padding: 2),
			.horizontalEdges
		)
		lineChart.pin(
			.allEdges
		)
	}

	private func setupBindings() {
		coinPerformanceVM.$chartVM.sink { chart in
			self.lineChart.chartVM = chart!
		}.store(in: &cancellables)
	}
}
