//
//  PaymentMethodOptionview.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/9/23.
//

import UIKit

class PaymentMethodOptionView: UIView {
	// MARK: - Public Properties

	public var paymentMethodOptionVM: PaymentMethodOptionViewModel? {
		didSet {
			setupView()
			setupConstraints()
			setupStyles()
		}
	}

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let infoStackView = UIStackView()
	private let textStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let rightIconInfoView = UIImageView()
	private let iconImageView = UIImageView()
    private let hapticManager = HapticManager()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainStackView)

		let onTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(onTapGesture)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionLabel)

		infoStackView.addArrangedSubview(iconImageView)
		infoStackView.addArrangedSubview(textStackView)

		mainStackView.addArrangedSubview(infoStackView)
		mainStackView.addArrangedSubview(rightIconInfoView)
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
		descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
		infoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

		mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 10))
		iconImageView.pin(.fixedHeight(44), .fixedWidth(44))
		rightIconInfoView.pin(.fixedWidth(28), .fixedHeight(28))
	}

	private func setupStyles() {
		guard let paymentMethodOptionVM else {
			fatalError("Cant access to paymentMethodOptionVM")
		}

		layer.cornerRadius = 12
		layer.borderWidth = 1
		layer.borderColor = UIColor.Pino.background.cgColor

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center

		infoStackView.axis = .horizontal
		infoStackView.spacing = 8

		textStackView.axis = .vertical
		textStackView.spacing = 4

		titleLabel.text = paymentMethodOptionVM.title
		titleLabel.font = .PinoStyle.semiboldCallout
		titleLabel.textColor = .Pino.primary
		titleLabel.numberOfLines = 0

		descriptionLabel.text = paymentMethodOptionVM.description
		descriptionLabel.font = .PinoStyle.mediumFootnote

		iconImageView.image = UIImage(named: paymentMethodOptionVM.iconName)

		rightIconInfoView.image = UIImage(named: paymentMethodOptionVM.rightIconInfoName)
	}

	@objc
	private func onTap() {
        hapticManager.run(type: .mediumImpact)
		let url = URL(string: paymentMethodOptionVM!.url)
		UIApplication.shared.open(url!)
	}
}
