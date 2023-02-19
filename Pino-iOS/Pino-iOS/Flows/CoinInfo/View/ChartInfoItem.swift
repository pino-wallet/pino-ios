//
//  ChartInfoItem.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import UIKit

class ChartInfoItems: UIView {
	// MARK: - Private Properties

	private let cellStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let itemTitleLabel = UILabel()
	private let itemValueLabel = UILabel()
	private let separatorLine = UIView()

	private let item: (key: String, value: String)
	private let separatorIsHidden: Bool

	// MARK: Initializers

	init(item: (key: String, value: String), separatorIsHidden: Bool = false) {
		self.item = item
		self.separatorIsHidden = separatorIsHidden
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
		titleStackView.addArrangedSubview(itemTitleLabel)
		titleStackView.addArrangedSubview(itemValueLabel)
		cellStackView.addArrangedSubview(titleStackView)
		cellStackView.addArrangedSubview(separatorLine)
		addSubview(cellStackView)
	}

	private func setupStyle() {
		itemTitleLabel.text = item.key
		itemValueLabel.text = item.value

		backgroundColor = .Pino.clear
		itemTitleLabel.textColor = .Pino.label
		itemValueLabel.textColor = .Pino.gray2
		separatorLine.backgroundColor = .Pino.gray5

		itemTitleLabel.font = .PinoStyle.mediumBody
		itemValueLabel.font = .PinoStyle.mediumBody

		itemValueLabel.textAlignment = .right

		titleStackView.axis = .horizontal
		cellStackView.axis = .vertical

		cellStackView.spacing = 14

		titleStackView.distribution = .fill
		cellStackView.alignment = .center

		separatorLine.isHidden = separatorIsHidden
	}

	private func setupContstraint() {
		cellStackView.pin(.allEdges)
		titleStackView.pin(
			.horizontalEdges(padding: 16)
		)
		separatorLine.pin(
			.fixedHeight(1),
			.leading(padding: 16),
			.trailing
		)
	}
}
