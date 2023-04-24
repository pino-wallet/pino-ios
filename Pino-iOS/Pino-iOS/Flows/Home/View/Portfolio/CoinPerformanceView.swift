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
	private let chartStackView = UIStackView()
	private let coinImage = UIImageView()
	private let coinName = UILabel()
	private let separatorLine = UIView()
	private let infoCardView = UIView()
	private let infoStackView = UIStackView()
	private let moreInfoTitle = UILabel()
	private var lineChart: AssetLineChart!

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
		lineChart = AssetLineChart(chartVM: coinPerformanceVM.chartVM, dateFilterChanged: { dateFilter in
			self.coinPerformanceVM.getChartData(dateFilter: dateFilter)
		})
		contentStackview.addArrangedSubview(chartCardView)
		contentStackview.addArrangedSubview(moreInfoStackView)
		moreInfoStackView.addArrangedSubview(moreInfoTitle)
		moreInfoStackView.addArrangedSubview(infoCardView)
		contentView.addSubview(contentStackview)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		infoCardView.addSubview(infoStackView)
		chartCardView.addSubview(chartStackView)
		chartStackView.addArrangedSubview(coinImage)
		chartStackView.addArrangedSubview(coinName)
		chartStackView.addArrangedSubview(separatorLine)
		chartStackView.addArrangedSubview(lineChart)

		infoStackView.addArrangedSubview(CoinPerformanceInfoItem(item: coinPerformanceVM.coinInfoVM.netProfit))
		infoStackView.addArrangedSubview(CoinPerformanceInfoItem(item: coinPerformanceVM.coinInfoVM.allTimeHigh))
		infoStackView.addArrangedSubview(CoinPerformanceInfoItem(item: coinPerformanceVM.coinInfoVM.allTimeLow))
	}

	private func setupStyle() {
		moreInfoTitle.text = "More info"
		coinName.text = coinPerformanceVM.coinInfoVM.name
		coinImage.image = UIImage(named: coinPerformanceVM.coinInfoVM.image)

		backgroundColor = .Pino.background
		chartCardView.backgroundColor = .Pino.secondaryBackground
		infoCardView.backgroundColor = .Pino.secondaryBackground
		contentView.backgroundColor = .Pino.clear
		scrollView.backgroundColor = .Pino.clear
		separatorLine.backgroundColor = .Pino.gray6

		moreInfoTitle.textColor = .Pino.label
		coinName.textColor = .Pino.label

		moreInfoTitle.font = .PinoStyle.semiboldTitle3
		coinName.font = .PinoStyle.semiboldTitle2

		contentStackview.axis = .vertical
		moreInfoStackView.axis = .vertical
		infoStackView.axis = .vertical
		chartStackView.axis = .vertical

		contentStackview.spacing = 34
		moreInfoStackView.spacing = 10
		chartStackView.spacing = 18

		chartStackView.alignment = .center

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
			.top(padding: 22),
			.bottom
		)
		chartCardView.pin(
			.fixedHeight(425)
		)
		infoStackView.pin(
			.verticalEdges(padding: 10),
			.horizontalEdges
		)
		chartStackView.pin(
			.horizontalEdges,
			.top(padding: 16),
			.bottom
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
			.horizontalEdges,
			.top(to: separatorLine, padding: 5)
		)
	}

	private func setupBindings() {
		coinPerformanceVM.$chartVM.sink { chart in
			guard let chart else { return }
			self.lineChart.chartVM = chart
		}.store(in: &cancellables)
	}
}
