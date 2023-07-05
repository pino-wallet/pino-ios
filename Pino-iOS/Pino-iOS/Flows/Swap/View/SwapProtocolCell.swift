//
//  SwapProtocolCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class SwapProtocolCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var swapProtocol: SwapProtocol! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let cellReuseID = "swapProtocolCell"

	// MARK: - Private Properties

	private let mainContainerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let swapProtocolImageView = UIImageView()
	private let swapProtocolTitleStackView = UIStackView()
	private let swapProtocolNameLabel = PinoLabel(style: .title, text: "")
	private let swapProtocolDescriptionLabel = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainContainerView)
		mainContainerView.addSubview(mainStackView)
		mainStackView.addArrangedSubview(swapProtocolImageView)
		mainStackView.addArrangedSubview(swapProtocolTitleStackView)
		swapProtocolTitleStackView.addArrangedSubview(swapProtocolNameLabel)
		swapProtocolTitleStackView.addArrangedSubview(swapProtocolDescriptionLabel)
	}

	private func setupStyles() {
		swapProtocolNameLabel.text = swapProtocol.name
		swapProtocolDescriptionLabel.text = swapProtocol.description

		swapProtocolImageView.image = UIImage(named: swapProtocol.image)

		swapProtocolNameLabel.font = .PinoStyle.mediumCallout
		swapProtocolDescriptionLabel.font = .PinoStyle.mediumFootnote

		swapProtocolNameLabel.numberOfLines = 0
		swapProtocolDescriptionLabel.numberOfLines = 0

		swapProtocolImageView.backgroundColor = .Pino.background
		swapProtocolImageView.layer.cornerRadius = 22

		swapProtocolTitleStackView.axis = .vertical

		mainStackView.spacing = 8
		swapProtocolTitleStackView.spacing = 4

		mainStackView.alignment = .center
	}

	private func setupConstraints() {
		mainContainerView.pin(
			.allEdges
		)
		mainStackView.pin(
			.leading,
			.verticalEdges(padding: 9)
		)
		swapProtocolImageView.pin(
			.fixedHeight(44),
			.fixedWidth(44)
		)
	}
}
