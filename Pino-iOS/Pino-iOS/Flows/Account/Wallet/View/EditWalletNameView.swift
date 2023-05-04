//
//  EditWalletNameView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

import UIKit

class EditWalletNameView: UIView {
	// MARK: - Typealiases

	typealias updateIsValidatedNameClosureType = (_ isValidated: Bool) -> Void

	// MARK: - Closures

	public var endEditingViewclosure: () -> Void = {}
	public let updateIsValidatedNameClosure: updateIsValidatedNameClosureType

	// MARK: - Public Properties

	public var editWalletNameVM: EditWalletNameViewModel
	public var selectedWalletVM: WalletInfoViewModel
	public var walletNameTextFieldView = PinoTextFieldView()
	public var doneButton = PinoButton(style: .active, title: "")

	// MARK: - Initializers

	init(
		editWalletNameVM: EditWalletNameViewModel,
		selectedWalletVM: WalletInfoViewModel,
		updateIsValidatedNameClosure: @escaping updateIsValidatedNameClosureType
	) {
		self.editWalletNameVM = editWalletNameVM
		self.selectedWalletVM = selectedWalletVM
		self.updateIsValidatedNameClosure = updateIsValidatedNameClosure
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

		walletNameTextFieldView.textDidChange = { [weak self] in
			if self?.walletNameTextFieldView.isEmpty() ?? false {
				self?.doneButton.style = .deactive
				self?.updateIsValidatedNameClosure(false)
			} else {
				self?.doneButton.style = .active
				self?.updateIsValidatedNameClosure(true)
			}
		}
		walletNameTextFieldView.textFieldKeyboardOnReturn = { [weak self] in
			self?.endEditingViewclosure()
		}

		walletNameTextFieldView.text = selectedWalletVM.name
		walletNameTextFieldView.placeholderText = editWalletNameVM.walletNamePlaceHolder

		doneButton.title = editWalletNameVM.doneButtonName
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
