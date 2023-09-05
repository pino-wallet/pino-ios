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

	public var isLoading = false {
		didSet {
			if isLoading {
				showLoading()
			} else {
				hideLoading()
			}
		}
	}

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let dexProtocolTitleStackView = UIStackView()
	private let dexProtocolImageview = UIImageView()
	private let dexProtocolTitleLabel = UILabel()
	private let dexProtocolSpacerView = UIView()
	private let dexProtocolArrowImageView = UIImageView()
	private var dexProtocolTitleLabelHeightConstraint: NSLayoutConstraint!

	// MARK: - Initializers

	init(title: String, image: String, onDexProtocolTapClosure: @escaping () -> Void) {
		self.titleText = title
		self.imageName = image
		self.onDexProtocolTapClosure = onDexProtocolTapClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupSkeletonViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		dexProtocolTitleLabelHeightConstraint = dexProtocolTitleLabel.heightAnchor.constraint(equalToConstant: 15)

		let dexProtocolTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDexProtocolTap))
		containerView.addGestureRecognizer(dexProtocolTapGesture)

		containerView.addSubview(mainStackView)
		mainStackView.addArrangedSubview(dexProtocolTitleStackView)
		mainStackView.addArrangedSubview(dexProtocolSpacerView)
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

		dexProtocolTitleStackView.axis = .horizontal
		dexProtocolTitleStackView.spacing = 8
		dexProtocolTitleStackView.alignment = .center

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center
	}

	private func setupConstraints() {
		dexProtocolTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true

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

	private func showLoading() {
		dexProtocolTitleLabelHeightConstraint.isActive = true
		showSkeletonView()
		dexProtocolArrowImageView.alpha = 0
	}

	private func hideLoading() {
		dexProtocolTitleLabelHeightConstraint.isActive = false
		hideSkeletonView()
		dexProtocolArrowImageView.alpha = 1
	}

	private func setupSkeletonViews() {
		dexProtocolImageview.isSkeletonable = true
		dexProtocolTitleLabel.isSkeletonable = true
	}

	@objc
	private func onDexProtocolTap() {
		if !isLoading {
			onDexProtocolTapClosure()
		}
	}
}
