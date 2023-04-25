//
//  CoinPerformanceInfoView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/24/23.
//

import UIKit

class CoinPerformanceInfoView: UIView {
	// MARK: Private Properties

	private let infoStackView = UIStackView()
	private var netProfitItem = CoinPerformanceInfoItem()
	private var allTimeHighItem = CoinPerformanceInfoItem()
	private var allTimeLowItem = CoinPerformanceInfoItem()

	// MARK: - Public Properties

	public var coinPerformanceInfoVM: CoinPerformanceInfoViewModel! {
		didSet {
			updateItems(coinPerformanceInfoVM)
		}
	}

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(infoStackView)
		infoStackView.addArrangedSubview(netProfitItem)
		infoStackView.addArrangedSubview(allTimeHighItem)
		infoStackView.addArrangedSubview(allTimeLowItem)
	}

	private func setupStyle() {
		netProfitItem.key = "Net profit"
		allTimeHighItem.key = "ATH"
		allTimeLowItem.key = "ATL"

		infoStackView.axis = .vertical
		backgroundColor = .Pino.secondaryBackground
		layer.cornerRadius = 12
	}

	private func setupConstraint() {
		infoStackView.pin(
			.verticalEdges(padding: 10),
			.horizontalEdges
		)
	}

	private func updateItems(_ coinInfoVM: CoinPerformanceInfoViewModel) {
		netProfitItem.value = coinInfoVM.netProfit
		allTimeHighItem.value = coinInfoVM.allTimeHigh
		allTimeLowItem.value = coinInfoVM.allTimeLow
	}
}
