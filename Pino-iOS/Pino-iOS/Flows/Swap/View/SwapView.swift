//
//  SwapView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation
import UIKit

class SwapView: UIView {
	// MARK: - Private Properties

	private let contentCardView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let switchTokenView = UIView()
	private let switchTokenLineView = UIView()
	private let switchTokenButton = UIButton()
	private let continueButton = PinoButton(style: .deactive)
	private var fromTokenSectionView: SwapTokenSectionView!
	private var toTokenSectionView: SwapTokenSectionView!

	private var fromTokenChange: () -> Void
	private var toTokeChange: () -> Void
	private var nextButtonTapped: () -> Void
	private var swapVM: SwapViewModel

	// MARK: - Internal Properties

	internal var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	internal var nextButtonBottomConstraint: NSLayoutConstraint!
	internal let nextButtonBottomConstant = CGFloat(12)

	// MARK: - Initializers

	init(
		swapVM: SwapViewModel,
		fromTokenChange: @escaping (() -> Void),
		toTokeChange: @escaping (() -> Void),
		nextButtonTapped: @escaping (() -> Void)
	) {
		self.fromTokenChange = fromTokenChange
		self.toTokeChange = toTokeChange
		self.nextButtonTapped = nextButtonTapped
		self.swapVM = swapVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupNotifications()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		fromTokenSectionView = SwapTokenSectionView(
			swapVM: swapVM.fromToken,
			changeSelectedToken: fromTokenChange,
			balanceStatusDidChange: { balanceStatus in
				self.updateSwapStatus(balanceStatus)
			}
		)

		toTokenSectionView = SwapTokenSectionView(
			swapVM: swapVM.toToken,
			hasMaxAmount: false,
			changeSelectedToken: toTokeChange
		)

		addSubview(contentCardView)
		addSubview(continueButton)
		contentCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(fromTokenSectionView)
		contentStackView.addArrangedSubview(switchTokenView)
		contentStackView.addArrangedSubview(toTokenSectionView)
		switchTokenView.addSubview(switchTokenLineView)
		switchTokenView.addSubview(switchTokenButton)

		continueButton.addAction(UIAction(handler: { _ in
			self.nextButtonTapped()
		}), for: .touchUpInside)

		switchTokenButton.addAction(UIAction(handler: { _ in
			self.switchTokens()
		}), for: .touchUpInside)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyle() {
		continueButton.title = swapVM.continueButtonTitle
		switchTokenButton.setImage(UIImage(named: swapVM.switchIcon), for: .normal)

		switchTokenButton.setTitleColor(.Pino.primary, for: .normal)

		backgroundColor = .Pino.background
		contentCardView.backgroundColor = .Pino.secondaryBackground
		switchTokenLineView.backgroundColor = .Pino.background
		switchTokenButton.backgroundColor = .Pino.background

		contentCardView.layer.cornerRadius = 12
		switchTokenButton.layer.cornerRadius = 12

		contentStackView.axis = .vertical
		contentStackView.spacing = 10
	}

	private func setupContstraint() {
		contentCardView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 18)
		)
		contentStackView.pin(
			.top(padding: 24),
			.bottom(padding: 28),
			.horizontalEdges
		)
		switchTokenLineView.pin(
			.horizontalEdges,
			.centerY,
			.fixedHeight(1)
		)
		switchTokenButton.pin(
			.fixedWidth(40),
			.fixedHeight(40),
			.verticalEdges,
			.centerX
		)
		continueButton.pin(
			.horizontalEdges(padding: 16)
		)
		nextButtonBottomConstraint = NSLayoutConstraint(
			item: continueButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -nextButtonBottomConstant
		)
		addConstraint(nextButtonBottomConstraint)
	}

	private func updateSwapStatus(_ status: AmountStatus) {
		switch status {
		case .isZero:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .isEnough:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
		case .isNotEnough:
			continueButton.setTitle(swapVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
		}
	}

	@objc
	private func dissmisskeyBoard() {}

	private func switchTokens() {}

	private func switchTextFieldsFocus() {}
}
