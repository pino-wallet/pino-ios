//
//  CoinInfoChartViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

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
	private let infoItems: [String: String]

	// MARK: Initializers

	init() {
		self.infoItems = [
			"Website": "Something.com",
			"Market Cap": "$465,836,000",
			"Valume (24h)": "19,476,500",
			"Circulating supply": "4,933,588",
			"Total supply": "4,933,588",
		]
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
		contentStackview.addArrangedSubview(cardStackView)
		contentStackview.addArrangedSubview(viewInExplorerButton)
		cardStackView.addArrangedSubview(chartCardView)
		cardStackView.addArrangedSubview(infoCardView)
		contentView.addSubview(contentStackview)
		scrollView.addSubview(contentView)
		addSubview(scrollView)

		for item in infoItems {
			if infoStackView.arrangedSubviews.count == infoItems.count - 1 {
				infoStackView.addArrangedSubview(ChartInfoItems(item: item, separatorIsHidden: true))
			} else {
				infoStackView.addArrangedSubview(ChartInfoItems(item: item))
			}
		}
		infoCardView.addSubview(infoStackView)
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

		contentStackview.spacing = 75
		cardStackView.spacing = 24

		infoStackView.spacing = 14
		infoCardView.layer.cornerRadius = 12
		chartCardView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		scrollView.pin(
			.allEdges
		)
		contentView.pin(
			.allEdges,
			.relative(.width, 0, to: self, .width)
		)
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 24),
			.bottom
		)
		chartCardView.pin(
			.fixedHeight(300)
		)
		infoStackView.pin(
			.verticalEdges(padding: 15),
			.horizontalEdges
		)
	}
}
