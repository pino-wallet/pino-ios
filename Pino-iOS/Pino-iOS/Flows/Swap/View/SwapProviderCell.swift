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
	private let swapProviderSpacerView = UIView()
	private let swapAmountLabel = PinoLabel(style: .title, text: "")

	// MARK: - Public Properties

	public var swapProviderVM: SwapProviderViewModel? {
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
		mainStackView.addArrangedSubview(swapProviderSpacerView)
		mainStackView.addArrangedSubview(swapAmountLabel)
		swapProviderTitleStackView.addArrangedSubview(swapProviderImageView)
		swapProviderTitleStackView.addArrangedSubview(swapProviderNameLabel)
	}

	private func setupStyles() {
		swapProviderNameLabel.font = .PinoStyle.mediumCallout
		swapAmountLabel.font = .PinoStyle.mediumCallout

		swapProviderNameLabel.numberOfLines = 0
		swapAmountLabel.numberOfLines = 0

		swapAmountLabel.textAlignment = .right

		swapProviderImageView.backgroundColor = .Pino.background
		mainContainerView.backgroundColor = .Pino.clear

		swapProviderTitleStackView.spacing = 10

		swapProviderTitleStackView.alignment = .center
		mainStackView.alignment = .center

		swapProviderImageView.layer.cornerRadius = 22
		mainContainerView.layer.cornerRadius = 12

		mainContainerView.layer.masksToBounds = true
		swapProviderImageView.layer.masksToBounds = true

		mainContainerView.frame = bounds

		swapProviderImageView.isSkeletonable = true
		swapProviderNameLabel.isSkeletonable = true
		swapAmountLabel.isSkeletonable = true

		if let swapProviderVM {
			swapProviderNameLabel.text = swapProviderVM.provider.name
			swapAmountLabel.text = swapProviderVM.formattedSwapAmountWithSymbol
			swapProviderImageView.image = UIImage(named: swapProviderVM.provider.image)
		} else {
			swapProviderNameLabel.text = nil
			swapAmountLabel.text = nil
		}
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

		NSLayoutConstraint.activate([
			swapProviderNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
			swapAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 64),
			swapProviderNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14),
			swapAmountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12),
		])
	}

	private func updateStyle(_ style: Style) {
		switch style {
		case .normal:
			mainContainerView.updateGradientColors([.Pino.gray5, .Pino.gray5])
		case .bestRate:
			mainContainerView.updateGradientColors([.Pino.green, .yellow, .Pino.orange, .purple])
		case .selected:
			mainContainerView.updateGradientColors([.Pino.green, .Pino.green])
		}
	}
}

extension SwapProviderCell {
	public enum Style {
		case normal
		case bestRate
		case selected
	}
}
