//
//  HomepgaeEmptyState.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/24.
//

import UIKit

class HomepageEmptyStateView: UICollectionReusableView {
	// MARK: - Public Properties

	public static let footerReuseID = "homepageEmptyState"
	public var manageAssetButton = UIButton()
	public var isEmptyState: Bool! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let emptyPageImageView = UIImageView()
	private let titleStackView = UIStackView()
	private let emptyPageTitle = UILabel()
	private let descriptionStackView = UIStackView()
	private let emptyPageDescription = UILabel()

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		contentStackview.addArrangedSubview(emptyPageImageView)
		contentStackview.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(emptyPageTitle)
		titleStackView.addArrangedSubview(descriptionStackView)
		descriptionStackView.addArrangedSubview(emptyPageDescription)
		descriptionStackView.addArrangedSubview(manageAssetButton)
	}

	private func setupStyle() {
		emptyPageImageView.image = UIImage(named: "home_empty_page")
		emptyPageTitle.text = "No assets"
		emptyPageDescription.text = "Manage your assets from"
		manageAssetButton.setTitle("here", for: .normal)

		backgroundColor = .Pino.background
		emptyPageTitle.textColor = .Pino.label
		emptyPageDescription.textColor = .Pino.secondaryLabel
		manageAssetButton.setTitleColor(.Pino.primary, for: .normal)

		emptyPageTitle.font = .PinoStyle.semiboldTitle2
		emptyPageDescription.font = .PinoStyle.mediumBody
		manageAssetButton.titleLabel?.font = .PinoStyle.boldBody

		contentStackview.axis = .vertical
		titleStackView.axis = .vertical

		contentStackview.alignment = .center
		titleStackView.alignment = .center
		descriptionStackView.alignment = .center

		contentStackview.spacing = 24
		titleStackView.spacing = -5
		descriptionStackView.spacing = -4
	}

	private func setupConstraint() {
		contentStackview.pin(
			.centerX
		)
		manageAssetButton.pin(
			.fixedWidth(56),
			.fixedHeight(56)
		)

		NSLayoutConstraint.activate([
			NSLayoutConstraint(
				item: contentStackview,
				attribute: .centerY,
				relatedBy: .equal,
				toItem: self,
				attribute: .centerY,
				multiplier: 0.7,
				constant: 0
			),
		])
	}
}
