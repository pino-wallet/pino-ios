//
//  InvestmentBoardCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import Combine
import UIKit

class InvestmentBoardCell: GroupCollectionViewCell {
	// MARK: - Public Properties

	public var asset: InvestAssetViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			setupBindings()
		}
	}

	public static let cellReuseID = "investmentBoardCellID"

	// MARK: - Private Propeties

	private let mainContainerView = UIView()
	private let mainStackView = UIStackView()
	private let assetNameLabel = PinoLabel(style: .title, text: "")
	private let assetImageView = InvestAssetImageView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Private Methods

	private func setupView() {
		mainStackView.addArrangedSubview(assetImageView)
		mainStackView.addArrangedSubview(assetNameLabel)
		mainContainerView.addSubview(mainStackView)
		cardView.addSubview(mainContainerView)
	}

	private func setupStyles() {
		assetNameLabel.text = asset.assetName
		assetImageView.assetImage = asset.assetImage
		assetImageView.protocolImage = asset.protocolImage

		assetNameLabel.font = .PinoStyle.semiboldSubheadline
		assetNameLabel.numberOfLines = 0

		mainContainerView.backgroundColor = .Pino.background

		mainStackView.axis = .horizontal
		mainStackView.spacing = 8
		mainStackView.alignment = .center

		mainContainerView.layer.cornerRadius = 12

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
			.leading(padding: 12),
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
