//
//  IntroCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/20/22.
//

import UIKit

public class IntroCollectionViewCell: UICollectionViewCell {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let introImage = UIImageView()
	private let titleStackView = UIStackView()
	private let introTitle = PinoLabel(style: .title, text: nil)
	private let introDescription = PinoLabel(style: .description, text: nil)

	// MARK: Public Properties

	public static let cellReuseID = "introCell"
	public var introModel: IntroModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			setImageCornerRadius()
		}
	}
}

extension IntroCollectionViewCell {
	// MARK: UI Methods

	private func setupView() {
		contentView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(introImage)
		contentStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(introTitle)
		titleStackView.addArrangedSubview(introDescription)
	}

	private func setupStyle() {
		contentStackView.axis = .vertical
		contentStackView.spacing = 56
		contentStackView.alignment = .center

		titleStackView.axis = .vertical
		titleStackView.spacing = 16
		titleStackView.alignment = .center

		introImage.image = UIImage(named: introModel.image)
		introImage.backgroundColor = .Pino.background

		introTitle.text = introModel.title
		introDescription.text = introModel.description
		introDescription.textAlignment = .center
	}

	private func setupConstraint() {
		introTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
		introDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

		contentStackView.pin(
			.horizontalEdges(padding: 33),
			.top(to: layoutMarginsGuide, padding: 37)
		)
		introImage.pin(.fixedWidth(240), .fixedHeight(240))
	}

	private func setImageCornerRadius() {
		layoutIfNeeded()
		introImage.layer.cornerRadius = introImage.frame.height / 2
	}
}
