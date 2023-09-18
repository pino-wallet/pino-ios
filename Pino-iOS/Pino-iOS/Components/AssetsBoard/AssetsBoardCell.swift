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
	private let amountSpacerView = UIView()
	private let assetImageView = InvestAssetImageView()
	private let assetNameLabel = UILabel()
	private let spacerView = UIView()
	private let sectionTopInsetView = UIView()
	private let sectionBottomInsetView = UIView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var isLoading = false {
		didSet {
			if isLoading {
				showLoading()
			} else {
				hideLoading()
			}
		}
	}

	// MARK: - Internal Properties

	internal let assetAmountLabel = UILabel()
	internal let assetAmountDescriptionLabel = UILabel()
	internal var asset: AssetsBoardProtocol? {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			setupBindings()
			setupSkeletonLoading()
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
		amountInfoStackView.addArrangedSubview(amountSpacerView)
	}

	private func setupStyles() {
		assetNameLabel.text = asset?.assetName
		assetImageView.assetImage = asset?.assetImage
		assetImageView.protocolImage = asset?.protocolImage

		assetNameLabel.textColor = .Pino.label

		assetNameLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.mediumCallout
		assetAmountDescriptionLabel.font = .PinoStyle.mediumFootnote

		assetAmountLabel.textAlignment = .right
		assetAmountDescriptionLabel.textAlignment = .right

		mainContainerView.backgroundColor = .Pino.background

		amountInfoStackView.axis = .vertical
		amountInfoStackView.alignment = .trailing

		contentStackView.axis = .vertical
		titleStackView.spacing = 8
		titleStackView.alignment = .center

		mainContainerView.layer.cornerRadius = 12
		cardView.layer.cornerRadius = 12

		separatorLineIsHiden = true
	}

	private func setupConstraints() {
		if !isLoading {
			hideLoading()
		}

		assetAmountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
		assetNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true
		assetAmountDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 11).isActive = true

		assetNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 76).isActive = true
		assetAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 37).isActive = true
		assetAmountDescriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true

		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 4)
		)
		assetImageView.pin(
			.fixedHeight(44),
			.fixedWidth(44)
		)
		mainStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 10)
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

	private func setupSkeletonLoading() {
		assetImageView.isSkeletonable = true
		assetNameLabel.isSkeletonable = true
		assetAmountLabel.isSkeletonable = true
		assetAmountDescriptionLabel.isSkeletonable = true
	}

	private func showLoading() {
		amountInfoStackView.spacing = 14
		amountInfoStackView.setCustomSpacing(5, after: assetAmountDescriptionLabel)
		amountSpacerView.isHidden = false
		layoutIfNeeded()
		showSkeletonView(backgroundColor: .Pino.background)
	}

	private func hideLoading() {
		amountInfoStackView.spacing = 4
		amountSpacerView.isHidden = true
		layoutIfNeeded()
		hideSkeletonView()
	}
}
