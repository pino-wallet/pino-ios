//
//  InvestView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Combine
import DGCharts
import UIKit

class InvestView: UIView {
	// MARK: Private Properties

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let chartCardView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let totalInvestmentView = UIView()
	private let totalInvestmentStackView = UIStackView()
	private let totalInvestmentTitleLabel = UILabel()
	private let totalInvestmentLabel = UILabel()
	private let totalInvestmentDetailIcon = UIImageView()
	private let chartStackView = UIStackView()
	private let chartView = UIView()
	private var lineChart = PinoLineChart(chartDataEntries: [])
	private var chartDateStackView = UIStackView()
	private var investmentPerformanceStackView = UIStackView()
	private let investmentPerformanceButton = UIButton()
	private let assetsView = UIView()
	private let investmentAssets: InvestmentAssetsCollectionView
	private let assetsGradientView = UIView()
	private var assetsGradientLayer: GradientLayer!
	private let loadingGradientView = UIView()
	private var loadingGradientLayer: GradientLayer!
	private var investVM: InvestViewModel
	private var totalInvestmentTapped: () -> Void
	private var investmentPerformanceTapped: () -> Void
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(
		investVM: InvestViewModel,
		totalInvestmentTapped: @escaping () -> Void,
		investmentPerformanceTapped: @escaping () -> Void
	) {
		self.investVM = investVM
		self.totalInvestmentTapped = totalInvestmentTapped
		self.investmentPerformanceTapped = investmentPerformanceTapped
		self.investmentAssets = InvestmentAssetsCollectionView(assets: investVM.assets)
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
		contentView.addSubview(chartCardView)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		chartCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(totalInvestmentView)
		contentStackView.addArrangedSubview(investmentPerformanceStackView)
		investmentPerformanceStackView.addArrangedSubview(chartStackView)
		investmentPerformanceStackView.addArrangedSubview(investmentPerformanceButton)
		chartStackView.addArrangedSubview(assetsView)
		chartStackView.addArrangedSubview(chartView)
		chartView.addSubview(lineChart)
		chartView.addSubview(loadingGradientView)
		chartStackView.addArrangedSubview(chartDateStackView)
		totalInvestmentView.addSubview(totalInvestmentStackView)
		totalInvestmentView.addSubview(totalInvestmentDetailIcon)
		totalInvestmentStackView.addArrangedSubview(totalInvestmentTitleLabel)
		totalInvestmentStackView.addArrangedSubview(totalInvestmentLabel)
		assetsView.addSubview(investmentAssets)
		assetsView.addSubview(assetsGradientView)

		setupChartDateFilter()

		let totalInvestmentGesture = UITapGestureRecognizer(target: self, action: #selector(showTotalInvestmentDetail))
		totalInvestmentView.addGestureRecognizer(totalInvestmentGesture)
		investmentPerformanceButton.addAction(UIAction(handler: { _ in
			self.investmentPerformanceTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		totalInvestmentTitleLabel.text = investVM.totalInvestmentTitle
		totalInvestmentLabel.text = investVM.totalInvestments
		investmentPerformanceButton.setTitle(investVM.investmentPerformamceTitle, for: .normal)
		investmentPerformanceButton.setImage(UIImage(named: investVM.investmentPerformanceIcon), for: .normal)
		totalInvestmentDetailIcon.image = UIImage(named: "arrow_right")

		backgroundColor = .Pino.background
		totalInvestmentView.backgroundColor = .Pino.primary
		contentView.backgroundColor = .Pino.clear
		scrollView.backgroundColor = .Pino.clear

		totalInvestmentTitleLabel.textColor = .Pino.white
		totalInvestmentLabel.textColor = .Pino.white
		totalInvestmentDetailIcon.tintColor = .Pino.green1
		investmentPerformanceButton.setTitleColor(.Pino.primary, for: .normal)
		investmentPerformanceButton.tintColor = .Pino.primary

		totalInvestmentTitleLabel.font = .PinoStyle.mediumCallout
		totalInvestmentLabel.font = .PinoStyle.semiboldLargeTitle

		investmentPerformanceButton.setConfiguraton(font: .PinoStyle.semiboldCallout!, imagePadding: 5)

		chartStackView.axis = .vertical
		contentStackView.axis = .vertical
		totalInvestmentStackView.axis = .vertical
		investmentPerformanceStackView.axis = .vertical

		contentStackView.spacing = 16
		totalInvestmentStackView.spacing = 22
		investmentPerformanceStackView.spacing = 36

		chartDateStackView.distribution = .fillEqually

		chartCardView.layer.masksToBounds = true
		assetsGradientView.isUserInteractionEnabled = false
	}

	private func setupContstraint() {
		scrollView.pin(
			.allEdges()
		)
		contentView.pin(
			.allEdges,
			.relative(.width, 0, to: self, .width)
		)
		chartCardView.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 24),
			.bottom
		)
		contentStackView.pin(
			.horizontalEdges,
			.top,
			.bottom(padding: 24)
		)
		totalInvestmentDetailIcon.pin(
			.fixedWidth(24),
			.fixedHeight(24),
			.top(padding: 16),
			.trailing(padding: 10)
		)
		totalInvestmentStackView.pin(
			.verticalEdges(padding: 20),
			.horizontalEdges(padding: 10)
		)
		assetsView.pin(
			.fixedHeight(80)
		)
		lineChart.pin(
			.allEdges,
			.fixedHeight(228)
		)
		loadingGradientView.pin(
			.allEdges(to: lineChart)
		)
		investmentAssets.pin(
			.allEdges
		)
		assetsGradientView.pin(
			.verticalEdges,
			.trailing,
			.fixedWidth(100)
		)
	}

	private func setupBindings() {
		investVM.$chartDataEntries.sink { chartEntries in
			if let chartEntries, !chartEntries.isEmpty {
				self.updateChart(chartEntries: chartEntries)
			} else {
				self.showLoading()
			}
		}.store(in: &cancellables)
	}

	@objc
	private func showTotalInvestmentDetail() {
		totalInvestmentTapped()
	}

	private func setupChartDateFilter() {
		let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
		for weekDay in weekDays {
			let dateLabel = UILabel()
			dateLabel.text = weekDay
			dateLabel.font = .PinoStyle.regularCaption1
			dateLabel.textColor = .Pino.secondaryLabel
			dateLabel.textAlignment = .center
			chartDateStackView.addArrangedSubview(dateLabel)
		}
	}

	private func showLoading() {
		lineChart.showLoading()
		loadingGradientView.alpha = 0.8
	}

	private func updateChart(chartEntries: [ChartDataEntry]) {
		loadingGradientView.alpha = 0
		lineChart.chartDataEntries = chartEntries
	}

	private func addLoadingGradient() {
		loadingGradientLayer?.removeFromSuperlayer()
		loadingGradientLayer = GradientLayer(
			frame: lineChart.bounds,
			colors: [.Pino.clear, .Pino.secondaryBackground],
			startPoint: CGPoint(x: 0, y: 0.5),
			endPoint: CGPoint(x: 1, y: 0.5)
		)
		loadingGradientView.layer.addSublayer(loadingGradientLayer)
	}

	private func addAssetsGradient() {
		assetsGradientLayer?.removeFromSuperlayer()
		assetsGradientLayer = GradientLayer(
			frame: assetsGradientView.bounds,
			colors: [.Pino.clear, .Pino.secondaryBackground],
			startPoint: CGPoint(x: 0, y: 0.5),
			endPoint: CGPoint(x: 1, y: 0.5)
		)
		assetsGradientView.layer.addSublayer(assetsGradientLayer)
	}

	// MARK: - Public Methods

	public func setupGradients() {
		addLoadingGradient()
		addAssetsGradient()
	}
}
