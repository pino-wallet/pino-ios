//
//  CoinPerformanceView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Combine
import DGCharts
import UIKit

class CoinPerformanceView: UIView {
	// MARK: Private Properties

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let contentStackview = UIStackView()
	private let moreInfoStackView = UIStackView()
	private let chartCardView = UIView()
	private let titleStackView = UIStackView()
	private let chartStackView = UIStackView()
	private let coinImage = UIImageView()
	private let coinName = UILabel()
	private let separatorLine = UIView()
	private let moreInfoTitle = UILabel()
	private let coinInfoView: CoinPerformanceInfoView
	private var lineChart: AssetLineChart!

	private let coinPerformanceVM: CoinPerformanceViewModel
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(coinPerformanceVM: CoinPerformanceViewModel) {
		self.coinPerformanceVM = coinPerformanceVM
		self.coinInfoView = CoinPerformanceInfoView(coinPerformanceVM: coinPerformanceVM)
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
		lineChart = AssetLineChart(chartVM: coinPerformanceVM.chartVM, dateFilterChanged: { dateFilter in
			self.coinPerformanceVM.getChartData(dateFilter: dateFilter)
		})

		contentStackview.addArrangedSubview(chartCardView)
		contentStackview.addArrangedSubview(moreInfoStackView)
		moreInfoStackView.addArrangedSubview(moreInfoTitle)
		moreInfoStackView.addArrangedSubview(coinInfoView)
		contentView.addSubview(contentStackview)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		chartCardView.addSubview(chartStackView)
		titleStackView.addArrangedSubview(coinImage)
		titleStackView.addArrangedSubview(coinName)
		titleStackView.addArrangedSubview(separatorLine)
		chartStackView.addArrangedSubview(titleStackView)
		chartStackView.addArrangedSubview(lineChart)
	}

	private func setupStyle() {
		moreInfoTitle.text = "More info"
		coinName.text = coinPerformanceVM.assetName

		coinImage.kf.indicatorType = .activity
		coinImage.kf.setImage(with: coinPerformanceVM.assetImage)

		backgroundColor = .Pino.background
		chartCardView.backgroundColor = .Pino.secondaryBackground
		contentView.backgroundColor = .Pino.clear
		scrollView.backgroundColor = .Pino.clear
		separatorLine.backgroundColor = .Pino.gray6

		moreInfoTitle.textColor = .Pino.label
		coinName.textColor = .Pino.label

		moreInfoTitle.font = .PinoStyle.semiboldTitle3
		coinName.font = .PinoStyle.semiboldTitle2

		contentStackview.axis = .vertical
		moreInfoStackView.axis = .vertical
		chartStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackview.spacing = 34
		moreInfoStackView.spacing = 10
		chartStackView.spacing = 5
		titleStackView.spacing = 16

		titleStackView.alignment = .center

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
			.top(padding: 22),
			.bottom
		)
		chartCardView.pin(
			.fixedHeight(425)
		)
		chartStackView.pin(
			.horizontalEdges,
			.top(padding: 16),
			.bottom()
		)
		coinImage.pin(
			.fixedWidth(48),
			.fixedHeight(48)
		)
		separatorLine.pin(
			.fixedHeight(1),
			.horizontalEdges
		)
		lineChart.pin(
			.horizontalEdges
		)
	}

	private func setupBindings() {
		coinPerformanceVM.$chartVM.sink { chart in
			guard let chart else { return }
			self.lineChart.chartVM = chart
		}.store(in: &cancellables)
	}
}
