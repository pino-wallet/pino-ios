//
//  InvestmentRiskView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/21/23.
//

import UIKit

class InvestmentRiskView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let highRiskCell: InvestmentRiskCell
	private let mediumRiskCell: InvestmentRiskCell
	private let lowRiskCell: InvestmentRiskCell

	private let riskDidSelect: (InvestmentRisk) -> Void

	// MARK: - Initializers

	init(riskDidSelect: @escaping (InvestmentRisk) -> Void) {
		self.riskDidSelect = riskDidSelect
		self.highRiskCell = InvestmentRiskCell(riskDidSelect: riskDidSelect)
		self.mediumRiskCell = InvestmentRiskCell(riskDidSelect: riskDidSelect)
		self.lowRiskCell = InvestmentRiskCell(riskDidSelect: riskDidSelect)
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
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(highRiskCell)
		contentStackview.addArrangedSubview(mediumRiskCell)
		contentStackview.addArrangedSubview(lowRiskCell)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		highRiskCell.investmentRisk = .high
		mediumRiskCell.investmentRisk = .medium
		lowRiskCell.investmentRisk = .low

		contentStackview.axis = .vertical
		contentStackview.spacing = 10
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 84)
		)
	}

	@objc
	private func highRiskDidSelect() {
		riskDidSelect(.high)
	}

	@objc
	private func mediumRiskDidSelect() {
		riskDidSelect(.medium)
	}

	@objc
	private func lowRiskDidSelect() {
		riskDidSelect(.low)
	}
}
