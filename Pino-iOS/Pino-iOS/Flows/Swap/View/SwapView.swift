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

	private var changePayToken: () -> Void
	private var changeGetToken: () -> Void
	private var nextButtonTapped: () -> Void
	private var swapVM: SwapViewModel

	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)

	// MARK: - Initializers

	init(
		swapVM: SwapViewModel,
		changePayToken: @escaping (() -> Void),
		changeGetToken: @escaping (() -> Void),
		nextButtonTapped: @escaping (() -> Void)
	) {
		self.changePayToken = changePayToken
		self.changeGetToken = changeGetToken
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
			changeSelectedToken: changePayToken,
			balanceStatusDidChange: { balanceStatus in
				self.updateSwapStatus(balanceStatus)
			}
		)

		toTokenSectionView = SwapTokenSectionView(
			swapVM: swapVM.toToken,
			hasMaxAmount: false,
			changeSelectedToken: changeGetToken
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

// MARK: - Keyboard Functions

extension SwapView {
	// MARK: - Private Methods

	private func setupNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	private func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
		// Keyboard's animation duration
		let keyboardDuration = notification
			.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

		// Keyboard's animation curve
		let keyboardCurve = UIView
			.AnimationCurve(
				rawValue: notification
					.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
			)!

		// Change the constant
		if keyboardWillShow {
			let safeAreaExists = (window?.safeAreaInsets.bottom != 0) // Check if safe area exists
			let keyboardOpenConstant = keyboardHeight - (safeAreaExists ? 70 : 0)
			nextButtonBottomConstraint.constant = -keyboardOpenConstant
		} else {
			nextButtonBottomConstraint.constant = -nextButtonBottomConstant
		}

		// Animate the view the same way the keyboard animates
		let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
			// Update Constraints
			self?.layoutIfNeeded()
		}

		// Perform the animation
		animator.startAnimation()
	}

	@objc
	private func keyboardWillShow(_ notification: NSNotification) {
		if let info = notification.userInfo {
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			//  Getting UIKeyboardSize.
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				let screenSize = UIScreen.main.bounds
				let intersectRect = kbFrame.intersection(screenSize)
				if intersectRect.isNull {
					keyboardHeight = 0
				} else {
					keyboardHeight = intersectRect.size.height
				}
			}
		}
		moveViewWithKeyboard(notification: notification, keyboardWillShow: true)
	}

	@objc
	private func keyboardWillHide(_ notification: NSNotification) {
		moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
	}
}
