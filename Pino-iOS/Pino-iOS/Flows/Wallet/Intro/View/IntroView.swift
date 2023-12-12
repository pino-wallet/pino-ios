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
	private let createWalletButton = PinoButton(style: .active)
	private let importWalletButton = UIButton()
	private let pageControl = UIPageControl()
	private var createWallet: () -> Void
	private var importWallet: () -> Void
	private var introVM: IntroViewModel

	// MARK: Initializers

	init(introVM: IntroViewModel, createWallet: @escaping (() -> Void), importWallet: @escaping (() -> Void)) {
		self.createWallet = createWallet
		self.importWallet = importWallet
		self.introVM = introVM
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
		introCollectionView.introContents = introVM.contentList

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
		createWalletButton.title = introVM.createButtonTitle
		importWalletButton.setTitle(introVM.importButtonTitle, for: .normal)

		backgroundColor = .Pino.secondaryBackground

		importWalletButton.setTitleColor(.Pino.primary, for: .normal)

		importWalletButton.titleLabel?.font = .PinoStyle.semiboldBody

		signinStackView.axis = .vertical

		signinStackView.spacing = 36

		signinStackView.alignment = .fill

		pageControl.numberOfPages = introVM.contentList.count
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = .Pino.primary
		pageControl.pageIndicatorTintColor = .Pino.gray5
	}

	private func setupContstraint() {
		introCollectionView.pin(
			.width(to: self),
			.relative(.bottom, -16, to: pageControl, .top),
			.top,
			.centerX
		)
		signinStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 1),
			.horizontalEdges(padding: 16)
		)
		pageControl.pin(
			.centerX,
			.relative(.bottom, -24, to: signinStackView, .top)
		)
	}
}
