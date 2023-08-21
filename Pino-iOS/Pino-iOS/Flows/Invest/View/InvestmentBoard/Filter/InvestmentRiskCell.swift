//
//  InvestmentRiskCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/21/23.
//

import UIKit

class InvestmentRiskCell: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = UILabel()
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let riskColorView = UIView()

	private let riskDidSelect: (InvestmentRisk) -> Void

	// MARK: - Public Properties

	public var risk: InvestmentRisk! {
		didSet {
			updateRiskInfo(risk)
		}
	}

	// MARK: - Initializers

	init(riskDidSelect: @escaping (InvestmentRisk) -> Void) {
		self.riskDidSelect = riskDidSelect
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
		contentStackview.addArrangedSubview(titleStackView)
		contentStackview.addArrangedSubview(descriptionLabel)
		titleStackView.addArrangedSubview(riskColorView)
		titleStackView.addArrangedSubview(titleLabel)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(riskItemDidTap)))
	}

	private func setupStyle() {
		titleLabel.font = .PinoStyle.semiboldCallout
		descriptionLabel.font = .PinoStyle.mediumSubheadline

		titleLabel.textColor = .Pino.label
		descriptionLabel.textColor = .Pino.secondaryLabel

		backgroundColor = .Pino.secondaryBackground

		contentStackview.axis = .vertical
		contentStackview.spacing = 12
		titleStackView.spacing = 4
		titleStackView.alignment = .center

		descriptionLabel.numberOfLines = 0

		layer.cornerRadius = 12
		riskColorView.layer.cornerRadius = 4
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 16)
		)
		riskColorView.pin(
			.fixedWidth(8),
			.fixedHeight(8)
		)
	}

	private func updateRiskInfo(_ risk: InvestmentRisk) {
		titleLabel.text = risk.title
		descriptionLabel.text = risk.description
		switch risk {
		case .high:
			riskColorView.backgroundColor = .Pino.red
		case .medium:
			riskColorView.backgroundColor = .Pino.orange
		case .low:
			riskColorView.backgroundColor = .Pino.green
		}
	}

	@objc
	private func riskItemDidTap() {
		riskDidSelect(risk)
	}
}
