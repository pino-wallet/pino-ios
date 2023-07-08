//
//  ProviderCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class SwapProviderCell: UICollectionViewCell {
	// MARK: - Private Properties

	private let mainContainerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let swapProviderImageView = UIImageView()
	private let swapProviderTitleStackView = UIStackView()
	private let swapProviderNameLabel = PinoLabel(style: .title, text: "")
	private let swapAmountLabel = PinoLabel(style: .title, text: "")

	// MARK: - Public Properties

	public var swapProvider: SwapProviderModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let cellReuseID = "swapProtocolCell"

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainContainerView)
		mainContainerView.addSubview(mainStackView)
		mainStackView.addArrangedSubview(swapProviderTitleStackView)
		mainStackView.addArrangedSubview(swapAmountLabel)
		swapProviderTitleStackView.addArrangedSubview(swapProviderImageView)
		swapProviderTitleStackView.addArrangedSubview(swapProviderNameLabel)
	}

	private func setupStyles() {
		swapProviderNameLabel.text = swapProvider.provider.name
		swapAmountLabel.text = swapProvider.swapAmount

		swapProviderImageView.image = UIImage(named: swapProvider.provider.image)

		swapProviderNameLabel.font = .PinoStyle.mediumCallout
		swapAmountLabel.font = .PinoStyle.mediumCallout

		swapProviderNameLabel.numberOfLines = 0
		swapAmountLabel.numberOfLines = 0

		swapAmountLabel.textAlignment = .right

		swapProviderImageView.backgroundColor = .Pino.background
		swapProviderImageView.layer.cornerRadius = 22

		swapProviderTitleStackView.spacing = 10

		mainContainerView.layer.borderColor = UIColor.Pino.gray5.cgColor
		mainContainerView.layer.borderWidth = 1
	}

	private func setupConstraints() {
		mainContainerView.pin(
			.allEdges,
			.fixedWidth(contentView.frame.width)
		)
		mainStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 10)
		)
		swapProviderImageView.pin(
			.fixedHeight(44),
			.fixedWidth(44)
		)
	}
}
