//
//  CoinInfoFooterview.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/17/23.
//

import UIKit

class CoinInfoFooterview: UICollectionReusableView {
	// MARK: - Public Properties

	public var coinInfoVM: CoinInfoViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			setupStylesFromCoinType()
		}
	}

	public static let footerReuseID = "coinInfoFooter"

	// MARK: - Private Properties

	private let noRecentHistoryMessageCard = UIView()
	private let noRecentHistoryMessageStackview = UIStackView()
	private let noRecentHistoryAlertIcon = UIImageView()
	private let noRecentHistoryMessageLabel = PinoLabel(style: .title, text: "")
	private let noRecentHistoryMessageIconContainer = UIView()
	private let noRecentHistoryMessageLabelRightSide = UIView()
	private let positionCoinInfoCard = UIView()
	private let positionCoinInfoLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		noRecentHistoryMessageIconContainer.addSubview(noRecentHistoryAlertIcon)

		noRecentHistoryMessageStackview.addArrangedSubview(noRecentHistoryMessageIconContainer)
		noRecentHistoryMessageStackview.addArrangedSubview(noRecentHistoryMessageLabel)
		noRecentHistoryMessageStackview.addArrangedSubview(noRecentHistoryMessageLabelRightSide)

		addSubview(noRecentHistoryMessageCard)
		noRecentHistoryMessageCard.addSubview(noRecentHistoryMessageStackview)

		positionCoinInfoCard.addSubview(positionCoinInfoLabel)

		addSubview(positionCoinInfoCard)
	}

	private func setupConstraints() {
		noRecentHistoryMessageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

		noRecentHistoryMessageCard.pin(.horizontalEdges(padding: 16), .top(padding: 16))
		noRecentHistoryMessageStackview.pin(.horizontalEdges(padding: 8), .verticalEdges(padding: 10))
		noRecentHistoryAlertIcon.pin(.fixedHeight(18), .fixedWidth(18))
		noRecentHistoryMessageIconContainer.pin(.fixedWidth(18))
		noRecentHistoryMessageLabelRightSide.pin(.fixedWidth(20))

		positionCoinInfoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true

		positionCoinInfoCard.pin(.top(padding: 16), .horizontalEdges(padding: 16))
		positionCoinInfoLabel.pin(.horizontalEdges(padding: 8), .verticalEdges(padding: 10))
	}

	private func setupStyles() {
		noRecentHistoryMessageStackview.axis = .horizontal
		noRecentHistoryMessageStackview.spacing = 4
		noRecentHistoryMessageStackview.distribution = .fillProportionally

		noRecentHistoryMessageCard.backgroundColor = .Pino.white
		noRecentHistoryMessageCard.layer.cornerRadius = 8

		noRecentHistoryAlertIcon.image = UIImage(named: coinInfoVM.unavailableRecentHistoryIconName)

		noRecentHistoryMessageLabel.font = .PinoStyle.mediumCallout
		noRecentHistoryMessageLabel.text = coinInfoVM.unavailableRecentHistoryText
		noRecentHistoryMessageLabel.numberOfLines = 0
		noRecentHistoryMessageLabel.lineBreakMode = .byWordWrapping

		positionCoinInfoCard.backgroundColor = .Pino.white
		positionCoinInfoCard.layer.cornerRadius = 8

		positionCoinInfoLabel.font = .PinoStyle.mediumCallout
		positionCoinInfoLabel.text = coinInfoVM.positionAssetInfoText
		positionCoinInfoLabel.numberOfLines = 0
	}

	private func setupStylesFromCoinType() {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			positionCoinInfoCard.isHidden = true
			noRecentHistoryMessageCard.isHidden = true
		case .unVerified:
			positionCoinInfoCard.isHidden = true
			noRecentHistoryMessageCard.isHidden = false
		case .position:
			positionCoinInfoCard.isHidden = false
			noRecentHistoryMessageCard.isHidden = true
		}
	}
}
