//
//  InvestmentRiskItemView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/22/23.
//

import UIKit

class RiskInfoItemView: UIStackView {
	// MARK: - Private Properties

	private let riskColorView = UIView()
	private let riskInfoLabel = UILabel()

	// MARK: - Public Properties

	public var riskInfo: String! {
		didSet {
			riskInfoLabel.text = riskInfo
		}
	}

	public var riskColor: String! {
		didSet {
			riskColorView.backgroundColor = UIColor(named: riskColor)
		}
	}

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addArrangedSubview(riskColorView)
		addArrangedSubview(riskInfoLabel)
	}

	private func setupStyle() {
		riskInfoLabel.font = .PinoStyle.mediumCallout
		riskInfoLabel.textColor = .Pino.label

		spacing = 6
		alignment = .center

		riskColorView.layer.cornerRadius = 4
	}

	private func setupConstraint() {
		riskColorView.pin(
			.fixedWidth(8),
			.fixedHeight(8)
		)
	}
}
