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
    private let textStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
    private let descriptionLabel = PinoLabel(style: .description, text: "")

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
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        
		mainStackView.addArrangedSubview(iconView)
		mainStackView.addArrangedSubview(textStackView)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.alignment = .center
        
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.spacing = 8

        titleLabel.font = .PinoStyle.semiboldTitle2
		titleLabel.text = emptyFooterVM.titleText
        
        descriptionLabel.font = .PinoStyle.mediumBody
        descriptionLabel.text = emptyFooterVM.descriptionText
        descriptionLabel.textAlignment = .center

		iconView.image = UIImage(named: emptyFooterVM.iconName)
	}

	private func setupConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
		iconView.pin(.fixedWidth(56), .fixedHeight(56))
		mainStackView.pin(.horizontalEdges(padding: 16), .bottom(padding: 0), .top(padding: 80))
	}
}
