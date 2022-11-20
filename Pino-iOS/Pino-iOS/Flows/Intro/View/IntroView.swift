//
//  IntroView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import UIKit

class IntroView: UIView {
	// MARK: Private Properties

	private let introCollectionView = IntroCollectionView()
	private let signinStackView = UIStackView()
	private let createWalletButton = PinoButton(style: .active, title: "Create New Wallet")
	private let importWalletButton = UIButton()
	private let pageControl = UIPageControl()
	private var createWallet: () -> Void
	private var importWallet: () -> Void
	private var introContent: [IntroModel]

	// MARK: Initializers

	init(content: [IntroModel], createWallet: @escaping (() -> Void), importWallet: @escaping (() -> Void)) {
		self.createWallet = createWallet
		self.importWallet = importWallet
		self.introContent = content
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
		addSubview(pageControl)
		addSubview(signinStackView)

		introCollectionView.pageDidChange = { currentPage in
			self.pageControl.currentPage = currentPage
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

		introCollectionView.introContents = introContent

		pageControl.numberOfPages = introContent.count
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = .Pino.primary
		pageControl.pageIndicatorTintColor = .Pino.gray4
	}

	private func setupContstraint() {
		introCollectionView.pin(
			.width(to: self),
			.bottom(padding: 334),
			.top(padding: 117),
			.centerX
		)
		signinStackView.pin(
			.bottom(padding: 36),
			.horizontalEdges(padding: 16)
		)
		createWalletButton.pin(
			.fixedHeight(56)
		)
		pageControl.pin(
			.centerX,
			.bottom(padding: 182)
		)
	}
}
