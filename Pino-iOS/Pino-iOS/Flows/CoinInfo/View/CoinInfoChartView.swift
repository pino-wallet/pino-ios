//
//  CoinInfoChartViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import Charts
import Combine
import UIKit

class CoinInfoChartView: UIView {
	// MARK: Private Properties

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let contentStackview = UIStackView()
	private let cardStackView = UIStackView()
	private let chartCardView = UIView()
	private let infoCardView = UIView()
	private let infoStackView = UIStackView()
	private let viewInExplorerButton = UIButton()
	private var lineChart: LineChart!
	private let coinInfoChartVM: CoinInfoChartViewModel

	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(coinInfoChartVM: CoinInfoChartViewModel) {
		self.coinInfoChartVM = coinInfoChartVM
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
		lineChart = LineChart(chartVM: coinInfoChartVM.chartVM, dateFilterChanged: { dateFilter in
			self.coinInfoChartVM.updateChartData(by: dateFilter)
		})
		contentStackview.addArrangedSubview(cardStackView)
		cardStackView.addArrangedSubview(chartCardView)
		cardStackView.addArrangedSubview(infoCardView)
		contentView.addSubview(contentStackview)
		contentView.addSubview(viewInExplorerButton)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		infoCardView.addSubview(infoStackView)
		chartCardView.addSubview(lineChart)

		infoStackView.addArrangedSubview(ChartInfoItems(item: coinInfoChartVM.aboutCoinVM.website))
		infoStackView.addArrangedSubview(ChartInfoItems(item: coinInfoChartVM.aboutCoinVM.marketCap))
		infoStackView.addArrangedSubview(ChartInfoItems(item: coinInfoChartVM.aboutCoinVM.Valume))
		infoStackView.addArrangedSubview(ChartInfoItems(item: coinInfoChartVM.aboutCoinVM.circulatingSupply))
		infoStackView
			.addArrangedSubview(ChartInfoItems(item: coinInfoChartVM.aboutCoinVM.totalSuply, separatorIsHidden: true))

		viewInExplorerButton.addAction(UIAction(handler: { _ in
			if let url = URL(string: self.coinInfoChartVM.aboutCoinVM.explorerURL) {
				UIApplication.shared.open(url)
			}
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		viewInExplorerButton.setTitle("View in explorer", for: .normal)
		viewInExplorerButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)

		viewInExplorerButton.setTitleColor(.Pino.primary, for: .normal)
		viewInExplorerButton.tintColor = .Pino.primary
		viewInExplorerButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 8)
		viewInExplorerButton.semanticContentAttribute = .forceRightToLeft

		backgroundColor = .Pino.background
		chartCardView.backgroundColor = .Pino.secondaryBackground
		infoCardView.backgroundColor = .Pino.secondaryBackground
		contentView.backgroundColor = .Pino.clear
		scrollView.backgroundColor = .Pino.clear

		contentStackview.axis = .vertical
		cardStackView.axis = .vertical
		infoStackView.axis = .vertical

//		contentStackview.spacing = 75
		cardStackView.spacing = 24
		infoStackView.spacing = 14

		viewInExplorerButton.contentMode = .bottom

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
			.fixedHeight(300)
		)
		infoStackView.pin(
			.verticalEdges(padding: 15),
			.horizontalEdges
		)
		lineChart.pin(
			.allEdges
		)
		viewInExplorerButton.pin(
			.centerX,
			.bottom(padding: 16)
		)

		NSLayoutConstraint.activate([
			contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: -90),
			viewInExplorerButton.topAnchor.constraint(
				greaterThanOrEqualTo: contentStackview.bottomAnchor,
				constant: 20
			),
		])
	}

	private func setupBindings() {
		coinInfoChartVM.$chartVM.sink { chart in
			self.lineChart.chartVM = chart!
		}.store(in: &cancellables)
	}
}
