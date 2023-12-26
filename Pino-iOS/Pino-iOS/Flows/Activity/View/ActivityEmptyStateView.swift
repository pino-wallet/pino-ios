//
//  ActivityEmptyStateView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/10/23.
//

import UIKit

class ActivityEmptyStateView: UIView {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleImageView = UIImageView()
	private let titleTextLabel = PinoLabel(style: .title, text: "")
    private let descriptionTextLabel = PinoLabel(style: .description, text: "")
    private let textStackView = UIStackView()
	private var titleText: String
	private var titleImageName: String
    private var descriptionText: String

	// MARK: - Initializers

    init(titleText: String, titleImageName: String, descriptionText: String) {
		self.titleText = titleText
		self.titleImageName = titleImageName
        self.descriptionText = descriptionText
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
        textStackView.addArrangedSubview(titleTextLabel)
        textStackView.addArrangedSubview(descriptionTextLabel)
        
		mainStackView.addArrangedSubview(titleImageView)
		mainStackView.addArrangedSubview(textStackView)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.alignment = .center
        
        titleTextLabel.font = .PinoStyle.semiboldTitle2
		titleTextLabel.text = titleText
        titleTextLabel.textAlignment = .center
        
        descriptionTextLabel.font = .PinoStyle.mediumBody
        descriptionTextLabel.text = descriptionText
        descriptionTextLabel.textAlignment = .center
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.alignment = .center

		titleImageView.image = UIImage(named: titleImageName)
	}

	private func setupConstraints() {
        titleTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        descriptionTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
		mainStackView.pin(.centerY, .horizontalEdges(padding: 16))
		titleImageView.pin(.fixedHeight(56), .fixedWidth(56))
	}
}
