//
//  SelectDexProtocolView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//

import UIKit

class SelectDexSystemView: UIView {
	// MARK: - Closures

	public var onDexProtocolTapClosure: () -> Void

	// MARK: - Public Properties

	public var titleText: String {
		didSet {
			dexProtocolTitleLabel.text = titleText
		}
	}

	public var imageName: String {
		didSet {
			dexProtocolImageview.image = UIImage(named: imageName)
		}
	}

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let dexProtocolTitleStackView = UIStackView()
	private let dexProtocolImageview = UIImageView()
	private let dexProtocolTitleLabel = UILabel()
	private let dexProtocolArrowImageView = UIImageView()

	// MARK: - Initializers

	init(title: String, image: String, onDexProtocolTapClosure: @escaping () -> Void) {
		self.titleText = title
		self.imageName = image
		self.onDexProtocolTapClosure = onDexProtocolTapClosure

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
		let dexProtocolTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDexProtocolTap))
		containerView.addGestureRecognizer(dexProtocolTapGesture)

		containerView.addSubview(mainStackView)
		mainStackView.addArrangedSubview(dexProtocolTitleStackView)
		mainStackView.addArrangedSubview(dexProtocolArrowImageView)
		dexProtocolTitleStackView.addArrangedSubview(dexProtocolImageview)
		dexProtocolTitleStackView.addArrangedSubview(dexProtocolTitleLabel)

		addSubview(containerView)
	}

	private func setupStyles() {
		dexProtocolArrowImageView.image = UIImage(named: "chevron_down")

		dexProtocolTitleLabel.font = .PinoStyle.mediumBody

		dexProtocolTitleLabel.textColor = .Pino.label

		dexProtocolArrowImageView.tintColor = .Pino.label

		dexProtocolImageview.image = UIImage(named: imageName)

		dexProtocolTitleLabel.text = titleText

		dexProtocolTitleStackView.spacing = 8

		mainStackView.alignment = .center
	}

	private func setupConstraints() {
		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 8)
		)
		dexProtocolImageview.pin(
			.fixedHeight(40),
			.fixedWidth(40)
		)
		dexProtocolArrowImageView.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
	}

	@objc
	private func onDexProtocolTap() {
		onDexProtocolTapClosure()
	}
}
