//
//  IntroView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import UIKit

class IntroView: UIView {
	// MARK: Private Properties

	private let introCollectionView = UIView()
	private let dotsStackView = UIStackView()
	private var dotsView: [UIImageView] = []
	private let signinStackView = UIStackView()
	private let createWalletButton = PinoButton(style: .active, title: "Create New Wallet")
	private let importWalletButton = UIButton()
	private var createWallet: () -> Void
	private var importWallet: () -> Void

	// MARK: Initializers

	init(createWallet: @escaping (() -> Void), importWallet: @escaping (() -> Void)) {
		self.createWallet = createWallet
		self.importWallet = importWallet
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension IntroView {
	// MARK: UI Methods

	private func setupView() {
		signinStackView.addArrangedSubview(createWalletButton)
		signinStackView.addArrangedSubview(importWalletButton)
		addSubview(introCollectionView)
		addSubview(dotsStackView)
		addSubview(signinStackView)
		for _ in 0 ..< 3 {
			let dotImageView = UIImageView()
			dotsView.append(dotImageView)
			dotsStackView.addArrangedSubview(dotImageView)
		}

		createWalletButton.addAction(UIAction(handler: { _ in
			self.createWallet()
		}), for: .touchUpInside)

		importWalletButton.addAction(UIAction(handler: { _ in
			self.importWallet()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		importWalletButton.setTitle("I already have a wallet", for: .normal)
		importWalletButton.setTitleColor(.Pino.label, for: .normal)
		importWalletButton.titleLabel?.font = .PinoStyle.semiboldBody

		signinStackView.axis = .vertical
		signinStackView.spacing = 40
		signinStackView.alignment = .fill

		dotsStackView.axis = .horizontal
		dotsStackView.spacing = 8

		for dotImageView in dotsView {
			let dotImage = UIImage(systemName: "circle.fill")
			dotImageView.image = dotImage
			dotImageView.tintColor = .Pino.background
		}
	}

	private func setupContstraint() {
		introCollectionView.pin(
			.horizontalEdges(padding: 48),
			.centerY
		)
		signinStackView.pin(
			.bottom(padding: 42),
			.horizontalEdges(padding: 16)
		)
		createWalletButton.pin(
			.fixedHeight(56)
		)
		dotsStackView.pin(
			.centerX,
			.bottom(padding: 189)
		)
		for dotImageView in dotsView {
			dotImageView.pin(
				.fixedHeight(8),
				.fixedWidth(8)
			)
		}
	}
}
