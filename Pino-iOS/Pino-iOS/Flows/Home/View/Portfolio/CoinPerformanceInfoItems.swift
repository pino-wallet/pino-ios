//
//  CoinPerformanceInfoItems.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/11/23.
//

//
//  PerformanceInfoItem.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import UIKit

class CoinPerformanceInfoItem: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let itemTitleLabel = UILabel()
	private let itemValueLabel = UILabel()
	private let spacerView = UIView()

	// MARK: - Public Properties

	public var key: String! {
		didSet {
			updateKey(key)
		}
	}

	public var value: String! {
		didSet {
			updateValue(value)
		}
	}

	// MARK: Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupSkeletonLoading()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(itemTitleLabel)
		contentStackView.addArrangedSubview(spacerView)
		contentStackView.addArrangedSubview(itemValueLabel)
		addSubview(contentStackView)
	}

	private func setupStyle() {
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
		itemValueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 11)
		)
	}

	private func updateValue(_ value: String) {
		itemValueLabel.text = value
	}

	private func updateKey(_ key: String) {
		itemTitleLabel.text = key
	}

	private func setupSkeletonLoading() {
		itemValueLabel.isSkeletonable = true
	}

	// MARK: - Public Methods

	public func setValueLabelColor(_ color: UIColor) {
		itemValueLabel.textColor = color
	}
}
