//
//  TokenView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/14/23.
//

import UIKit

class TokenView: UIView {
	// MARK: - Private Properties

	private let tokenStackView = UIStackView()
	private let tokenNameLabel = UILabel()
	private let tokenImageView = UIImageView()

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

	public var tokenTapped: (() -> Void)?

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

		let tokenGesture = UITapGestureRecognizer(target: self, action: #selector(tokenViewTapped))
		addGestureRecognizer(tokenGesture)
	}

	private func setupStyle() {
		tokenNameLabel.font = .PinoStyle.mediumCallout
		tokenNameLabel.textColor = .Pino.label

		backgroundColor = .Pino.clear
		layer.cornerRadius = 20
		layer.borderColor = UIColor.Pino.background.cgColor
		layer.borderWidth = 1

		tokenStackView.spacing = 4
	}

	private func setupConstraint() {
		tokenImageView.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
		tokenStackView.pin(
			.verticalEdges(padding: 6),
			.horizontalEdges(padding: 8)
		)
	}

	@objc
	private func tokenViewTapped() {
		guard let tokenTapped else { return }
		tokenTapped()
	}
}
