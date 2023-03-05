//
//  PerformanceInfoItem.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import UIKit

class CoinInfoItem: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let itemTitleLabel = UILabel()
	private let itemValueLabel = UILabel()

	private let item: (key: String, value: String)

	// MARK: Initializers

	init(item: (key: String, value: String)) {
		self.item = item
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
		contentStackView.addArrangedSubview(itemTitleLabel)
		contentStackView.addArrangedSubview(itemValueLabel)
		addSubview(contentStackView)
	}

	private func setupStyle() {
		itemTitleLabel.text = item.key
		itemValueLabel.text = item.value

		backgroundColor = .Pino.clear
		itemTitleLabel.textColor = .Pino.secondaryLabel
		itemValueLabel.textColor = .Pino.label

		itemTitleLabel.font = .PinoStyle.mediumBody
		itemValueLabel.font = .PinoStyle.mediumBody

		itemValueLabel.textAlignment = .right

		contentStackView.axis = .horizontal
		contentStackView.distribution = .fill
	}

	private func setupContstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 11)
		)
	}
}
