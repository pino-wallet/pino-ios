//
//  InvestmentBoardCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import Combine
import UIKit

class InvestmentBoardCell: GroupCollectionViewCell {
	// MARK: - Private Propeties

	private let mainContainerView = UIView()
	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let amountInfoStackView = UIStackView()
	private let assetImageView = InvestAssetImageView()
	private let assetNameLabel = UILabel()
	private let assetAmountLabel = UILabel()
	private let assetAmountDescriptionLabel = UILabel()
	private let spacerView = UIView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public static let cellReuseID = "investmentBoardCellID"

	public var asset: InvestAssetViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			setupBindings()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		cardView.addSubview(mainContainerView)
		mainContainerView.addSubview(mainStackView)
		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(spacerView)
		mainStackView.addArrangedSubview(amountInfoStackView)
		titleStackView.addArrangedSubview(assetImageView)
		titleStackView.addArrangedSubview(assetNameLabel)
		amountInfoStackView.addArrangedSubview(assetAmountLabel)
		amountInfoStackView.addArrangedSubview(assetAmountDescriptionLabel)
	}

	private func setupStyles() {
		assetNameLabel.text = asset.assetName
		assetAmountLabel.text = asset.formattedAssetAmount
		assetImageView.assetImage = asset.assetImage
		assetImageView.protocolImage = asset.protocolImage

		switch asset.volatilityType {
		case .profit:
			assetAmountDescriptionLabel.text = "+\(asset.formattedAssetVolatility)"
			assetAmountDescriptionLabel.textColor = .Pino.green
		case .loss:
			assetAmountDescriptionLabel.text = "-\(asset.formattedAssetVolatility)"
			assetAmountDescriptionLabel.textColor = .Pino.red
		case .none:
			assetAmountDescriptionLabel.text = asset.formattedAssetVolatility
			assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel
		}

		assetNameLabel.textColor = .Pino.label
		assetAmountLabel.textColor = .Pino.label

		assetNameLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.mediumCallout
		assetAmountDescriptionLabel.font = .PinoStyle.mediumFootnote

		assetAmountLabel.textAlignment = .right
		assetAmountDescriptionLabel.textAlignment = .right

		mainContainerView.backgroundColor = .Pino.background

		amountInfoStackView.axis = .vertical
		titleStackView.spacing = 8

		mainContainerView.layer.cornerRadius = 12
		cardView.layer.cornerRadius = 12

		separatorLineIsHiden = true
	}

	private func setupConstraints() {
		mainContainerView.pin(
			.horizontalEdges(padding: 14)
		)
		assetImageView.pin(
			.fixedHeight(50),
			.fixedWidth(50)
		)
		mainStackView.pin(
			.horizontalEdges(padding: 12),
			.verticalEdges(padding: 8)
		)
	}

	private func setupBindings() {
		$style.sink { style in
			guard let style else { return }
			self.updateConstraint(style: style)
		}.store(in: &cancellables)
	}

	private func updateConstraint(style: GroupCollectionViewStyle) {
		var topPadding: CGFloat
		var bottomPadding: CGFloat

		switch style {
		case .firstCell:
			topPadding = 14
			bottomPadding = 4
		case .lastCell:
			topPadding = 4
			bottomPadding = 14
		case .regular:
			topPadding = 4
			bottomPadding = 4
		case .singleCell:
			topPadding = 14
			bottomPadding = 14
		}

		mainContainerView.pin(
			.top(padding: topPadding),
			.bottom(padding: bottomPadding)
		)
	}
}
