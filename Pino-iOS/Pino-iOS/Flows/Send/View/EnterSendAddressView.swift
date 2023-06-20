//
//  EnterSendAddressView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//

import UIKit

class EnterSendAddressView: UIView {
	// MARK: - Closures

	public var tapNextButton: () -> Void = {}
	public var scanAddressQRCode: () -> Void = {}

	// MARK: - Private Propterties

	private let nextButton = PinoButton(style: .deactive)
	private let nextButtonBottomConstant = CGFloat(12)
	private let qrCodeScanButton = UIButton()
	private let suggestedAddressesVM = SuggestedAddressesViewModel()
	private let suggestedAddressesContainerView = PinoContainerCard(cornerRadius: 8)
	private var suggestedAddressesCollectionView: SuggestedAddressesCollectionView!
	private var enterSendAddressVM: EnterSendAddressViewModel
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var nextButtonBottomConstraint: NSLayoutConstraint!

	// MARK: - Public Properties

	public let addressTextField = PinoTextFieldView()

	public var validationStatus: EnterSendAddressViewModel.ValidationStatus = .normal {
		didSet {
			changeViewStatus(validationStatus: validationStatus)
		}
	}

	// MARK: - Initializers

	init(enterSendAddressVM: EnterSendAddressViewModel) {
		self.enterSendAddressVM = enterSendAddressVM

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupNotifications()
		configureKeyboard()
		changeViewStatus(validationStatus: validationStatus)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		suggestedAddressesCollectionView = SuggestedAddressesCollectionView(suggestedAddressesVM: suggestedAddressesVM)
		addressTextField.textDidChange = {
			self.enterSendAddressVM.validateSendAddress(address: self.addressTextField.getText() ?? "")
		}

		nextButton.addAction(UIAction(handler: { _ in
			self.tapNextButton()
		}), for: .touchUpInside)

		qrCodeScanButton.addAction(UIAction(handler: { _ in
			self.scanAddressQRCode()
		}), for: .touchUpInside)

		suggestedAddressesContainerView.addSubview(suggestedAddressesCollectionView)

		addSubview(addressTextField)
		addSubview(suggestedAddressesContainerView)
		addSubview(nextButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		qrCodeScanButton.setImage(UIImage(named: enterSendAddressVM.qrCodeIconName), for: .normal)

		addressTextField.placeholderText = enterSendAddressVM.enterAddressPlaceholder

		nextButton.title = enterSendAddressVM.nextButtonTitle

		suggestedAddressesContainerView.layer.borderWidth = 1
		suggestedAddressesContainerView.layer.borderColor = UIColor.Pino.gray5.cgColor
	}

	private func setupConstraints() {
		nextButtonBottomConstraint = NSLayoutConstraint(
			item: nextButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -nextButtonBottomConstant
		)
		addConstraint(nextButtonBottomConstraint)

		addressTextField.pin(.top(to: layoutMarginsGuide, padding: 24), .horizontalEdges(padding: 16))
		suggestedAddressesContainerView.pin(
			.relative(.top, 8, to: addressTextField, .bottom),
			.horizontalEdges(padding: 16),
			.fixedHeight(400),
			.bottom(to: nextButton, .top, padding: 21)
		)
		suggestedAddressesCollectionView.pin(.allEdges(padding: 0))
		nextButton.pin(.horizontalEdges(padding: 16))
	}

	private func changeViewStatus(validationStatus: EnterSendAddressViewModel.ValidationStatus) {
		switch validationStatus {
		case let .error(error):
			addressTextField.errorText = error.description
			addressTextField.style = .error

			nextButton.style = .deactive
		case .success:
			addressTextField.style = .success

			nextButton.style = .active
		case .pending:
			addressTextField.style = .pending

			nextButton.style = .deactive
		case .normal:
			addressTextField.style = .customIcon(qrCodeScanButton)

			nextButton.style = .deactive
		}
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

	private func configureKeyboard() {
		addressTextField.textFieldKeyboardOnReturn = {
			self.endEditing(true)
		}
		let endEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
		addGestureRecognizer(endEditingTapGesture)
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
	private func viewEndEditing() {
		endEditing(true)
	}
}

extension EnterSendAddressView {
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
