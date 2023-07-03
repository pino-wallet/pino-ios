//
//  SwapTokenView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation
import UIKit

class SwapTokenView: UIView {
	// MARK: - Private Properties

	private let tokenStackView = UIStackView()
	private let tokenNameLabel = UILabel()
	private let tokenImageView = UIImageView()
	private let changeTokenIcon = UIImageView()

	// MARK: - Public Properties

	public var tokenName: String? {
		didSet {
			tokenNameLabel.text = tokenName
		}
	}

	public var tokenImageURL: URL? {
		didSet {
			tokenImageView.kf.indicatorType = .activity
			tokenImageView.kf.setImage(with: tokenImageURL)
		}
	}

	public var customTokenImage: String? {
		didSet {
			guard let customTokenImage else { return }
			tokenImageView.image = UIImage(named: customTokenImage)
		}
	}

	public var tokenViewDidSelect: (() -> Void)!

	// MARK: Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenNameLabel)
		tokenStackView.addArrangedSubview(changeTokenIcon)

		let tokenGesture = UITapGestureRecognizer(target: self, action: #selector(tokenViewTapped))
		addGestureRecognizer(tokenGesture)
	}

	private func setupStyle() {
		changeTokenIcon.image = UIImage(named: "arrow_down_2")
		tokenNameLabel.font = .PinoStyle.mediumCallout
		tokenNameLabel.textColor = .Pino.label

		backgroundColor = .Pino.background
		layer.cornerRadius = 20
		layer.borderColor = UIColor.Pino.background.cgColor
		layer.borderWidth = 1

		tokenStackView.spacing = 4
		tokenStackView.alignment = .center
	}

	private func setupConstraint() {
		tokenImageView.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
		changeTokenIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		tokenStackView.pin(
			.verticalEdges(padding: 6),
			.horizontalEdges(padding: 8)
		)
	}

	@objc
	private func tokenViewTapped() {
		tokenViewDidSelect()
	}
}
