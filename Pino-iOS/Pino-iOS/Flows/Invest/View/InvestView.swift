//
//  InvestView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

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
	private var lineChart = UIView()
	private let investmentPerformanceButton = UIButton()

	// MARK: Initializers

	init() {
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
		contentView.addSubview(chartCardView)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		chartCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(totalInvestmentView)
		contentStackView.addArrangedSubview(chartStackView)
		chartStackView.addArrangedSubview(lineChart)
		chartStackView.addArrangedSubview(investmentPerformanceButton)
		totalInvestmentView.addSubview(totalInvestmentStackView)
		totalInvestmentView.addSubview(totalInvestmentDetailIcon)
		totalInvestmentStackView.addArrangedSubview(totalInvestmentTitleLabel)
		totalInvestmentStackView.addArrangedSubview(totalInvestmentLabel)
	}

	private func setupStyle() {
		totalInvestmentTitleLabel.text = "Total investment value"
		totalInvestmentLabel.text = "$25,091"
		investmentPerformanceButton.setTitle("Investment performance", for: .normal)
		investmentPerformanceButton.setImage(UIImage(named: "Invest"), for: .normal)
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

		chartStackView.spacing = 5
		contentStackView.spacing = 16
		totalInvestmentStackView.spacing = 22

		chartCardView.layer.masksToBounds = true
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
			.fixedHeight(425),
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
		lineChart.pin(
			.horizontalEdges
		)
	}
}
