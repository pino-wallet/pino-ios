//
//  InvestmentBoardCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import Combine
import UIKit

class AssetsBoardCell: GroupCollectionViewCell {
	// MARK: - Private Propeties

	private let contentStackView = UIStackView()
	private let mainContainerView = UIView()
	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let amountInfoStackView = UIStackView()
	private let assetImageView = InvestAssetImageView()
	private let assetNameLabel = UILabel()
	private let spacerView = UIView()
	private let sectionTopInsetView = UIView()
	private let sectionBottomInsetView = UIView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal let assetAmountLabel = UILabel()
	internal let assetAmountDescriptionLabel = UILabel()
	internal var asset: AssetsBoardProtocol! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			setupBindings()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		cardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(sectionTopInsetView)
		contentStackView.addArrangedSubview(mainContainerView)
		contentStackView.addArrangedSubview(sectionBottomInsetView)
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
		assetImageView.assetImage = asset.assetImage
		assetImageView.protocolImage = asset.protocolImage

		assetNameLabel.textColor = .Pino.label

		assetNameLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.mediumCallout
		assetAmountDescriptionLabel.font = .PinoStyle.mediumFootnote

		assetAmountLabel.textAlignment = .right
		assetAmountDescriptionLabel.textAlignment = .right

		mainContainerView.backgroundColor = .Pino.background

		amountInfoStackView.axis = .vertical
		contentStackView.axis = .vertical
		titleStackView.spacing = 8

		mainContainerView.layer.cornerRadius = 12
		cardView.layer.cornerRadius = 12

		separatorLineIsHiden = true
	}

	private func setupConstraints() {
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 4)
		)
		assetImageView.pin(
			.fixedHeight(50),
			.fixedWidth(50)
		)
		mainStackView.pin(
			.horizontalEdges(padding: 12),
			.verticalEdges(padding: 8)
		)
		sectionTopInsetView.pin(
			.fixedHeight(10)
		)
		sectionBottomInsetView.pin(
			.fixedHeight(10)
		)
	}

	private func setupBindings() {
		$style.sink { style in
			guard let style else { return }
			self.updateConstraint(style: style)
		}.store(in: &cancellables)
	}

	private func updateConstraint(style: GroupCollectionViewStyle) {
		switch style {
		case .firstCell:
			sectionTopInsetView.isHiddenInStackView = false
			sectionBottomInsetView.isHiddenInStackView = true
		case .lastCell:
			sectionTopInsetView.isHiddenInStackView = true
			sectionBottomInsetView.isHiddenInStackView = false
		case .regular:
			sectionTopInsetView.isHiddenInStackView = true
			sectionBottomInsetView.isHiddenInStackView = true
		case .singleCell:
			sectionTopInsetView.isHiddenInStackView = false
			sectionBottomInsetView.isHiddenInStackView = false
		}
	}
}
