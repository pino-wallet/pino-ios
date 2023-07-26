//
//  ImageAndTitleStackView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/12/23.
//

import UIKit

class ImageAndTitleStackView: UIStackView {
	// MARK: - Public Properties

	public var image: String? {
		didSet {
			imageView.image = UIImage(named: image ?? "")
		}
	}

	public var title: String? {
		didSet {
			titleLabel.text = title
			titleLabel.numberOfLines = 0
		}
	}

	// MARK: - Private Properties

	private let imageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")

	// MARK: - Initializers

	init(image: String?, title: String?) {
		self.image = image
		self.title = title

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addArrangedSubview(imageView)
		addArrangedSubview(titleLabel)
	}

	private func setupStyles() {
		axis = .horizontal
		spacing = 2
		alignment = .center

		titleLabel.font = .PinoStyle.mediumBody
		titleLabel.text = title
		titleLabel.numberOfLines = 0

		imageView.image = UIImage(named: image ?? "")
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true

		imageView.pin(.fixedWidth(20), .fixedHeight(20))
	}
}
