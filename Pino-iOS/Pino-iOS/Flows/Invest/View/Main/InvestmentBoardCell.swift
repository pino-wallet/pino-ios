//
//  InvestmentBoardCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import UIKit

class InvestmentBoardCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var asset: InvestAssetViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let cellReuseID = "investmentBoardCellID"

	// MARK: - Private Propeties

	private let mainContainerView = UIView()
	private let mainStackView = UIStackView()
	private let logoContainer = UIView()
	private let logoTextLabel = PinoLabel(style: .title, text: "")
	private let shortEndAddressLabelContainer = UIView()
	private let shortEndAddressLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		logoContainer.addSubview(logoTextLabel)

		shortEndAddressLabelContainer.addSubview(shortEndAddressLabel)

		mainStackView.addArrangedSubview(logoContainer)
		mainStackView.addArrangedSubview(shortEndAddressLabelContainer)

		mainContainerView.addSubview(mainStackView)

		addSubview(mainContainerView)
	}

	private func setupStyles() {
		mainStackView.axis = .horizontal
		mainStackView.spacing = 8
		mainStackView.alignment = .center

		logoContainer.layer.cornerRadius = 22
		logoContainer.backgroundColor = .Pino.green1

		logoTextLabel.font = .PinoStyle.semiboldSubheadline
		logoTextLabel.textColor = .Pino.primary
		logoTextLabel.text = asset.assetName

		shortEndAddressLabel.font = .PinoStyle.semiboldSubheadline
		shortEndAddressLabel.text = asset.assetName
		shortEndAddressLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
		shortEndAddressLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true

		mainContainerView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 0))
		shortEndAddressLabel.pin(.allEdges(padding: 0))
		logoContainer.pin(.fixedHeight(44), .fixedWidth(44))
		logoTextLabel.pin(.centerY(), .centerX())
		mainStackView.pin(.leading(padding: 0), .verticalEdges(padding: 0))
	}
}
