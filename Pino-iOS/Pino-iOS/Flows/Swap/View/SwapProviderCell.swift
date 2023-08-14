//
//  ProviderCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class SwapProviderCell: UICollectionViewCell {
	// MARK: - Private Properties

	private var mainContainerView = GradientBorderView()
	private let mainStackView = UIStackView()
	private let swapProviderImageView = UIImageView()
	private let swapProviderTitleStackView = UIStackView()
	private let swapProviderNameLabel = PinoLabel(style: .title, text: "")
	private let swapAmountLabel = PinoLabel(style: .title, text: "")

	// MARK: - Public Properties

	public var swapProviderVM: SwapProviderViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public var cellStyle: Style! {
		didSet {
			updateStyle(cellStyle)
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
		swapProviderNameLabel.text = swapProviderVM.provider.name
		swapAmountLabel.text = swapProviderVM.formattedSwapAmountWithSymbol

		swapProviderImageView.image = UIImage(named: swapProviderVM.provider.image)

		swapProviderNameLabel.font = .PinoStyle.mediumCallout
		swapAmountLabel.font = .PinoStyle.mediumCallout

		swapProviderNameLabel.numberOfLines = 0
		swapAmountLabel.numberOfLines = 0

		swapAmountLabel.textAlignment = .right

		swapProviderImageView.backgroundColor = .Pino.background
		mainContainerView.backgroundColor = .Pino.clear

		swapProviderTitleStackView.spacing = 10

		swapProviderImageView.layer.cornerRadius = 22
		mainContainerView.layer.cornerRadius = 12
		mainContainerView.layer.masksToBounds = true

		mainContainerView.frame = bounds
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

	private func updateStyle(_ style: Style) {
		switch style {
		case .normal:
			mainContainerView.updateGradientColors([.Pino.gray5, .Pino.gray5])
		case .bestRate:
			mainContainerView.updateGradientColors([.Pino.green, .yellow, .Pino.orange, .purple])
		}
	}
}

extension SwapProviderCell {
	public enum Style {
		case normal
		case bestRate
	}
}
