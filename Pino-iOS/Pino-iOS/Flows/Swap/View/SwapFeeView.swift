//
//  SwapFeeView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import UIKit

class SwapFeeView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let saveAmountStackView = UIStackView()
	private let providerStackView = UIStackView()
	private let priceImpactStackView = UIStackView()
	private let feeStackView = UIStackView()
	private let amountLabel = UILabel()
	private let amountSpacerView = UIView()
	private let impactTagStackView = UIStackView()
	private let impactTagView = UIView()
	private let impactTagLabel = UILabel()
	private let collapsButton = UIButton()
	private let saveAmountTitleLabel = UILabel()
	private let saveAmountLabel = UILabel()
	private let providerTitle = UILabel()
	private let providerChangeStackView = UIStackView()
	private let providerImageView = UIImageView()
	private let providerNameLabel = UILabel()
	private let providerChangeIcon = UIImageView()
	private let priceImpactTitleLabel = UILabel()
	private let priceImpactLabel = UILabel()
	private let feeTitleLabel = UILabel()
	private let feeLabel = UILabel()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(amountStackView)
		contentStackView.addArrangedSubview(saveAmountStackView)
		contentStackView.addArrangedSubview(providerStackView)
		contentStackView.addArrangedSubview(priceImpactStackView)
		contentStackView.addArrangedSubview(feeStackView)
		amountStackView.addArrangedSubview(amountLabel)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(impactTagStackView)
		impactTagStackView.addArrangedSubview(impactTagView)
		impactTagStackView.addArrangedSubview(collapsButton)
		impactTagView.addSubview(impactTagLabel)
		saveAmountStackView.addArrangedSubview(saveAmountTitleLabel)
		saveAmountStackView.addArrangedSubview(saveAmountLabel)
		providerStackView.addArrangedSubview(providerTitle)
		providerStackView.addArrangedSubview(providerChangeStackView)
		providerChangeStackView.addArrangedSubview(providerImageView)
		providerChangeStackView.addArrangedSubview(providerNameLabel)
		providerChangeStackView.addArrangedSubview(providerChangeIcon)
		priceImpactStackView.addArrangedSubview(priceImpactTitleLabel)
		priceImpactStackView.addArrangedSubview(priceImpactLabel)
		feeStackView.addArrangedSubview(feeTitleLabel)
		feeStackView.addArrangedSubview(feeLabel)
	}

	private func setupStyle() {
		amountLabel.text = "1 SNT = 1,450 DAI"
		impactTagLabel.text = "High impact"
		saveAmountTitleLabel.text = "You save"
		saveAmountLabel.text = "$3 🎉"
		providerTitle.text = "Provider"
		providerNameLabel.text = "1inch"
		priceImpactTitleLabel.text = "Price impact"
		priceImpactLabel.text = "%2"
		feeTitleLabel.text = "Fee"
		feeLabel.text = "$20"

		collapsButton.setImage(UIImage(named: "arrow_up2"), for: .normal)
		providerImageView.image = UIImage(named: "1inch")
		providerChangeIcon.image = UIImage(named: "arrow_right2")

		amountLabel.font = .PinoStyle.mediumBody
		impactTagLabel.font = .PinoStyle.semiboldFootnote
		saveAmountTitleLabel.font = .PinoStyle.mediumBody
		saveAmountLabel.font = .PinoStyle.mediumBody
		providerTitle.font = .PinoStyle.mediumBody
		providerNameLabel.font = .PinoStyle.mediumBody
		feeTitleLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		priceImpactTitleLabel.font = .PinoStyle.mediumBody
		priceImpactLabel.font = .PinoStyle.mediumBody

		amountLabel.textColor = .Pino.label
		impactTagLabel.textColor = .Pino.orange
		saveAmountTitleLabel.textColor = .Pino.secondaryLabel
		saveAmountLabel.textColor = .Pino.green
		providerTitle.textColor = .Pino.secondaryLabel
		providerNameLabel.textColor = .Pino.label
		feeTitleLabel.textColor = .Pino.secondaryLabel
		feeLabel.textColor = .Pino.label
		priceImpactTitleLabel.textColor = .Pino.secondaryLabel
		priceImpactLabel.textColor = .Pino.orange

		collapsButton.tintColor = .Pino.label
		providerChangeIcon.tintColor = .Pino.secondaryLabel

		impactTagView.backgroundColor = .Pino.lightOrange

		saveAmountLabel.textAlignment = .right

		contentStackView.axis = .vertical

		contentStackView.spacing = 20
		impactTagStackView.spacing = 2
		providerChangeStackView.spacing = 3

		providerChangeStackView.alignment = .center
		impactTagStackView.alignment = .center

		impactTagView.layer.cornerRadius = 14
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 15)
		)
		impactTagView.pin(
			.fixedHeight(28)
		)
		impactTagLabel.pin(
			.horizontalEdges(padding: 8),
			.centerY
		)
		collapsButton.pin(
			.fixedWidth(24),
			.fixedHeight(24)
		)
		providerImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		providerChangeIcon.pin(
			.fixedWidth(16),
			.fixedHeight(16)
		)
	}
}
