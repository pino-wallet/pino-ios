//
//  CoinInfoEmptyStateFooterView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/26/23.
//

import UIKit

class CoinInfoEmptyStateFooterView: UICollectionReusableView {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let iconView = UIImageView()
	private let titleLabel = PinoLabel(style: .info, text: "")

	// MARK: - Public Properties

	public static let emptyStateFooterID = "emotyStateFooterID"

	public var emptyFooterVM: CoinInfoEmptyStateFooterViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		mainStackView.addArrangedSubview(iconView)
		mainStackView.addArrangedSubview(titleLabel)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 16
		mainStackView.alignment = .center

		titleLabel.textColor = .Pino.secondaryLabel

		titleLabel.text = emptyFooterVM.titleText

		iconView.image = UIImage(named: emptyFooterVM.iconName)
	}

	private func setupConstraints() {
		iconView.pin(.fixedWidth(53), .fixedHeight(53))
		mainStackView.pin(.horizontalEdges(padding: 16), .bottom(padding: 0), .top(padding: 64))
	}
}
