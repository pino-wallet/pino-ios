//
//  EditWalletNameView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

import UIKit

class EditWalletNameView: UIView {
	// MARK: - Public Properties

	public var walletNameTextFieldView: PinoTextFieldView
	public var doneButton: PinoButton

	// MARK: - Initializers

	init(walletNameTextFieldView: PinoTextFieldView, doneButton: PinoButton) {
		self.walletNameTextFieldView = walletNameTextFieldView
		self.doneButton = doneButton
		super.init(frame: .zero)

		setupNotifications()
		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private let doneButtonBottomConstant = CGFloat(12)
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var doneButtonBottomConstraint: NSLayoutConstraint!

	// MARK: - Private Methods

	private func setupView() {
		addSubview(walletNameTextFieldView)
		addSubview(doneButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background
	}

	private func setupConstraints() {
		doneButtonBottomConstraint = NSLayoutConstraint(
			item: doneButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -doneButtonBottomConstant
		)
		addConstraint(doneButtonBottomConstraint)

		walletNameTextFieldView.pin(.horizontalEdges(padding: 16), .top(to: layoutMarginsGuide, padding: 24))
		doneButton.pin(.horizontalEdges(padding: 16))
	}

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
			let keyboardOpenConstant = keyboardHeight - (safeAreaExists ? 20 : 0)
			doneButtonBottomConstraint.constant = -keyboardOpenConstant
		} else {
			doneButtonBottomConstraint.constant = -doneButtonBottomConstant
		}

		// Animate the view the same way the keyboard animates
		let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
			// Update Constraints
			self?.layoutIfNeeded()
		}

		// Perform the animation
		animator.startAnimation()
	}
}

extension EditWalletNameView {
	// swiftlint: redundant_void_return
	@objc
	internal func keyboardWillShow(_ notification: NSNotification) {
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
	internal func keyboardWillHide(_ notification: NSNotification) {
		moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
	}
}
