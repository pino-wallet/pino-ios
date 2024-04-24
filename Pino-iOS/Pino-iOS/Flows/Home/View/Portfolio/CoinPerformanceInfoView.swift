//
//  CoinPerformanceInfoView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/24/23.
//

import Combine
import UIKit

class CoinPerformanceInfoView: UIView {
	// MARK: Private Properties

	private let infoStackView = UIStackView()
	private var netProfitItem = CoinPerformanceInfoItem()
	private var allTimeHighItem = CoinPerformanceInfoItem()
	private var allTimeLowItem = CoinPerformanceInfoItem()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var coinPerformanceVM: CoinPerformanceInfoViewModel!

	init(coinPerformanceVM: CoinPerformanceInfoViewModel) {
		self.coinPerformanceVM = coinPerformanceVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
		setupBindings()
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
		netProfitItem.key = coinPerformanceVM.netProfitTitle
		allTimeHighItem.key = coinPerformanceVM.allTimeHighTitle
		allTimeLowItem.key = coinPerformanceVM.allTimeLowTitle

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

	private func updateItems(allTimeHigh: String, allTimeLow: String, netProfit: String) {
		netProfitItem.value = netProfit
		allTimeHighItem.value = allTimeHigh
		allTimeLowItem.value = allTimeLow
	}

	private func setNetProfitLabelColor() {
		if coinPerformanceVM.netProfitBigNum.isZero {
			netProfitItem.setValueLabelColor(.Pino.label)
		} else if coinPerformanceVM.netProfitBigNum > 0.bigNumber {
			netProfitItem.setValueLabelColor(.Pino.green)
		} else if coinPerformanceVM.netProfitBigNum < 0.bigNumber {
			netProfitItem.setValueLabelColor(.Pino.red)
		}
	}

	private func setupBindings() {
		Publishers.Zip3(coinPerformanceVM.$allTimeHigh, coinPerformanceVM.$allTimeLow, coinPerformanceVM.$netProfit)
			.sink { allTimeHigh, allTimeLow, netProfit in
				guard let allTimeHigh, let allTimeLow, let netProfit else {
					self.layoutSubviews()
					self.showSkeletonView()
					return
				}
				self.updateItems(allTimeHigh: allTimeHigh, allTimeLow: allTimeLow, netProfit: netProfit)
				self.setNetProfitLabelColor()
				self.hideSkeletonView()
			}.store(in: &cancellables)
	}
}
