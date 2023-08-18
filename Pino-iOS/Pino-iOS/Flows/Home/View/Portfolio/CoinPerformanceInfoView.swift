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

	private func updateItems(_ coinInfoVM: CoinPerformanceInfoValues) {
		netProfitItem.value = coinInfoVM.netProfit
		allTimeHighItem.value = coinInfoVM.allTimeHigh
		allTimeLowItem.value = coinInfoVM.allTimeLow
	}

	private func setupBindings() {
		coinPerformanceVM.$coinPerformanceInfo.sink { coinInfo in
			guard let coinInfo else { return }
			self.updateItems(coinInfo)
		}.store(in: &cancellables)
	}
}
