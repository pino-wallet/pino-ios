//
//  CreatePassView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Foundation
import UIKit

class ManagePasscodeView: UIView {
	// MARK: Private Properties

	private let managePassTitle = PinoLabel(style: .title, text: nil)
	private let managePassDescription = PinoLabel(style: .description, text: nil)
	private let topInfoContainerView = UIStackView()
	private let errorLabel = UILabel()
	private let managePassVM: PasscodeManagerPages
	private let errorInfoStackView = UIStackView()
	private let errorInfoStackViewBottomConstant = CGFloat(40)
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var errorInfoStackViewBottomConstraint: NSLayoutConstraint!
	private let keyboardview = PinoNumberPadView()

	// MARK: Public Properties

	public let passDotsView: PassDotsView

	// MARK: Initializers

	init(managePassVM: PasscodeManagerPages) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
		keyboardview.delegate = passDotsView
		super.init(frame: .zero)

		setupNotifications()
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ManagePasscodeView {
	// MARK: Private Methods

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

	private func setupView() {
		topInfoContainerView.addArrangedSubview(managePassTitle)
		topInfoContainerView.addArrangedSubview(managePassDescription)

		errorInfoStackView.addArrangedSubview(errorLabel)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
		addSubview(errorInfoStackView)
		addSubview(keyboardview)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18

		managePassTitle.text = managePassVM.title
		managePassDescription.text = managePassVM.description

		errorLabel.isHidden = true
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = UIFont.PinoStyle.mediumTitle3

		errorInfoStackView.axis = .vertical
	}

	// MARK: - Public Methods

	public func showErrorWith(text: String) {
		errorLabel.text = text
		errorLabel.textAlignment = .center
		errorLabel.isHidden = false
	}

	public func hideError() {
		errorLabel.isHidden = true
	}

	private func setupContstraint() {
		errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
		errorInfoStackViewBottomConstraint = NSLayoutConstraint(
			item: errorInfoStackView,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -errorInfoStackViewBottomConstant
		)
		addConstraint(errorInfoStackViewBottomConstraint)

		topInfoContainerView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.relative(.top, 85, to: topInfoContainerView, .bottom),
			.centerX(),
			.fixedHeight(20)
		)

		errorInfoStackView.pin(
			.horizontalEdges(padding: 16)
		)

		keyboardview.pin(
			.horizontalEdges(padding: 62.5),
			.bottom(to: layoutMarginsGuide, padding: 44)
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
			errorInfoStackViewBottomConstraint.constant = -keyboardOpenConstant
		} else {
			errorInfoStackViewBottomConstraint.constant = -errorInfoStackViewBottomConstant
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

extension ManagePasscodeView {
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
