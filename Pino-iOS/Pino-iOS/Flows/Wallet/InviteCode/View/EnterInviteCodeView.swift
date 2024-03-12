//
//  EnterInviteCodeView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/30/23.
//

import Combine
import Foundation
import UIKit

class EnterInviteCodeView: UIView, UITextFieldDelegate {
	// MARK: - Closures

	private let dismissViewClosure: () -> Void
	private let presentGetInviteCodeClosure: () -> Void

	// MARK: - Private Properties

	private var enterInviteCodeVM: EnterInviteCodeViewModel
	private let clearNavigationBar = ClearNavigationBar()
	private let navigationDismissButton = UIButton()
	private let navigationBarRightSideView = UIView()
	private let mainStackView = UIStackView()
	private let textsStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let codeTextField = PinoTextFieldView(pattern: .alphaNumeric)
	private let getCodeButton = PinoButton(style: .clear)
	private let buttonsStackView = UIStackView()
	private var nextButton = PinoButton(style: .deactive)
	private var buttonsStackViewBottomConstraint: NSLayoutConstraint!
	private let buttonsStackViewBottomConstant = CGFloat(12)
	private var keyboardHeight: CGFloat = 320
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		enterInviteCodeVM: EnterInviteCodeViewModel,
		dismissViewClosure: @escaping () -> Void,
		presentGetInviteCodeClosure: @escaping () -> Void
	) {
		self.enterInviteCodeVM = enterInviteCodeVM
		self.dismissViewClosure = dismissViewClosure
		self.presentGetInviteCodeClosure = presentGetInviteCodeClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		setupNotifications()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let dismissKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisskeyBoard))
		addGestureRecognizer(dismissKeyboardGestureRecognizer)

		codeTextField.textFieldKeyboardOnReturn = {
			self.dismisskeyBoard()
		}

		codeTextField.textDidChange = {
			self.validateInviteCode()
		}

		navigationDismissButton.addTarget(self, action: #selector(onDismissSelf), for: .touchUpInside)

		getCodeButton.addTarget(self, action: #selector(onGetInviteCode), for: .touchUpInside)
		nextButton.addTarget(self, action: #selector(onDismissSelf), for: .touchUpInside)

		navigationBarRightSideView.addSubview(navigationDismissButton)

		clearNavigationBar.setRightSectionView(view: navigationBarRightSideView)

		textsStackView.addArrangedSubview(titleLabel)
		textsStackView.addArrangedSubview(descriptionLabel)

		mainStackView.addArrangedSubview(textsStackView)
		mainStackView.addArrangedSubview(codeTextField)

		buttonsStackView.addArrangedSubview(nextButton)
		buttonsStackView.addArrangedSubview(getCodeButton)

		addSubview(clearNavigationBar)
		addSubview(mainStackView)
		addSubview(buttonsStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		navigationDismissButton.setImage(UIImage(named: enterInviteCodeVM.navbarDismissImageName), for: .normal)

		mainStackView.axis = .vertical
		mainStackView.spacing = 48

		textsStackView.axis = .vertical
		textsStackView.spacing = 12

		titleLabel.text = enterInviteCodeVM.titleText

		descriptionLabel.text = enterInviteCodeVM.describtionText

		codeTextField.placeholderText = enterInviteCodeVM.codePlaceHolder

		buttonsStackView.axis = .vertical
		buttonsStackView.spacing = 12

		nextButton.title = enterInviteCodeVM.nextButtonText

		getCodeButton.title = enterInviteCodeVM.getCodeText
	}

	private func setupBindings() {
		enterInviteCodeVM.$inviteCodeStatus.compactMap { $0 }.sink { inviteCodeStatus in
			self.updateUIWith(status: inviteCodeStatus)
		}.store(in: &cancellables)
	}

	private func setupConstraints() {
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		navigationDismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		mainStackView.pin(.relative(.top, 5, to: clearNavigationBar, .bottom), .horizontalEdges(padding: 16))
		buttonsStackView.pin(.horizontalEdges(padding: 16))

		buttonsStackViewBottomConstraint = NSLayoutConstraint(
			item: buttonsStackView,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -buttonsStackViewBottomConstant
		)
		addConstraint(buttonsStackViewBottomConstraint)
	}

	private func updateUIWith(status: EnterInviteCodeViewModel.InviteCodeStatus) {
		switch status {
		case .sucess:
			codeTextField.style = .success
			nextButton.style = .active
			nextButton.title = "Confirm"
		case .notFound:
			codeTextField.style = .error
			nextButton.style = .deactive
			nextButton.title = "Not Found"
		case .alreadyUsed:
			codeTextField.style = .error
			nextButton.style = .deactive
			nextButton.title = "Already Used"
		}
	}

	@objc
	private func onDismissSelf() {
		dismissViewClosure()
	}

	@objc
	private func onGetInviteCode() {
		presentGetInviteCodeClosure()
	}

	@objc
	private func validateInviteCode() {
        guard let inviteCode = codeTextField.text, !inviteCode.isEmpty else {
            codeTextField.style = .normal
            nextButton.style = .deactive
            nextButton.title = "Next"
            return
        }
		if inviteCode.count == 12 {
			codeTextField.style = .pending
			nextButton.style = .deactive
            nextButton.title = "Please wait"
			enterInviteCodeVM.activateDeviceForBeta(inviteCode: inviteCode)
        } else {
            codeTextField.style = .normal
            nextButton.style = .deactive
            nextButton.title = "Not valid"
        }
	}
}

// MARK: - Keyboard Functions

extension EnterInviteCodeView {
	// MARK: - Private Methods

	@objc
	private func dismisskeyBoard() {
		codeTextField.endEditing(true)
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
			buttonsStackView.spacing = keyboardOpenConstant - 68
		} else {
			buttonsStackView.spacing = 12
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
