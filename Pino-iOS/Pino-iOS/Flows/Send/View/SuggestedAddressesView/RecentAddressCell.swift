//
//  RecentAddressCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import UIKit

class RecentAddressCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var recentAddressVM: RecentAddressViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let cellReuseID = "RecentAddressCellID"

	// MARK: - Private Propeties

	private let mainContainerView = UIView()
	private let mainStackView = UIStackView()
	private let logoContainer = UIView()
    private let textsStackView = UIStackView()
	private let logoTextLabel = PinoLabel(style: .title, text: "")
    private let relativeDateLabel = PinoLabel(style: .description, text: "")
	private let shortEndAddressLabelContainer = UIView()
	private let shortEndAddressLabel = PinoLabel(style: .title, text: "")

	// MARK: - Private Methods

	private func setupView() {
		logoContainer.addSubview(logoTextLabel)

		shortEndAddressLabelContainer.addSubview(shortEndAddressLabel)
        
        textsStackView.addArrangedSubview(shortEndAddressLabelContainer)
        textsStackView.addArrangedSubview(relativeDateLabel)

		mainStackView.addArrangedSubview(logoContainer)
		mainStackView.addArrangedSubview(textsStackView)

		mainContainerView.addSubview(mainStackView)

		addSubview(mainContainerView)
	}

	private func setupStyles() {
		mainStackView.axis = .horizontal
		mainStackView.spacing = 8
		mainStackView.alignment = .center
        
        textsStackView.axis = .vertical

		logoContainer.layer.cornerRadius = 22
		logoContainer.backgroundColor = .Pino.green1

		logoTextLabel.font = .PinoStyle.semiboldSubheadline
		logoTextLabel.textColor = .Pino.primary
		logoTextLabel.text = recentAddressVM.logoText
        
        relativeDateLabel.font = .PinoStyle.mediumSubheadline

		shortEndAddressLabel.font = .PinoStyle.semiboldSubheadline
		shortEndAddressLabel.text = recentAddressVM.shortEndAddress
		shortEndAddressLabel.numberOfLines = 0
        
        relativeDateLabel.text = recentAddressVM.relativeDate
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
		shortEndAddressLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        shortEndAddressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        relativeDateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

		mainContainerView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 0))
		shortEndAddressLabel.pin(.allEdges(padding: 0))
		logoContainer.pin(.fixedHeight(44), .fixedWidth(44))
		logoTextLabel.pin(.centerY(), .centerX())
		mainStackView.pin(.leading(padding: 0), .verticalEdges(padding: 0))
	}
}
