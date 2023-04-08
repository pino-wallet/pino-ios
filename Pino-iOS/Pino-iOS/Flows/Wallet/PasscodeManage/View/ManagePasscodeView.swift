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
	private let spaceBetweenTopView = UIView()
	private let useFaceIdAndErrorStackView = UIStackView()
	private let useFaceIDOptionStackView = UIStackView()
	private let useFaceIDIcon = UIImageView()
	private let useFaceIDTitleLabel = PinoLabel(style: .title, text: "")
	private let useFaceIDSwitch = UISwitch()
	private let useFaceIDIconContainer = UIView()
	private let useFaceIDbetweenStackView = UIStackView()
	private let useFaceIDInfoStackView = UIStackView()
    private let useFaceIdAndErrorStackViewBottomConstant = CGFloat(40)
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
    private var useFaceIdAndErrorStackViewBottomConstraint: NSLayoutConstraint!

	// MARK: Public Properties

	public let passDotsView: PassDotsView
	public var isUnlockMode = false {
		didSet {
			setupUnlockModeStyles()
		}
	}

	public var hasFaceIDMode = false {
		didSet {
			setupFaceIDOptionStyles()
		}
	}

	// MARK: - Closures

	public var onSuccessUnlockClosure: (() -> Void)!

	// MARK: Initializers

	init(managePassVM: PasscodeManagerPages) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupView() {
		topInfoContainerView.addArrangedSubview(managePassTitle)
		topInfoContainerView.addArrangedSubview(spaceBetweenTopView)
		topInfoContainerView.addArrangedSubview(managePassDescription)

		useFaceIDIconContainer.addSubview(useFaceIDIcon)
		useFaceIDInfoStackView.addArrangedSubview(useFaceIDIconContainer)
		useFaceIDInfoStackView.addArrangedSubview(useFaceIDTitleLabel)

		useFaceIDOptionStackView.addArrangedSubview(useFaceIDInfoStackView)
		useFaceIDOptionStackView.addArrangedSubview(useFaceIDbetweenStackView)
		useFaceIDOptionStackView.addArrangedSubview(useFaceIDSwitch)

		useFaceIdAndErrorStackView.addArrangedSubview(errorLabel)
		useFaceIdAndErrorStackView.addArrangedSubview(useFaceIDOptionStackView)

		useFaceIDSwitch.addTarget(self, action: #selector(onUseFaceIDSwitchChange), for: .valueChanged)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
		addSubview(useFaceIdAndErrorStackView)
	}

	private func setupStyle() {
		useFaceIDInfoStackView.axis = .horizontal
		useFaceIDInfoStackView.spacing = 4

		backgroundColor = .Pino.secondaryBackground

		spaceBetweenTopView.isHidden = true

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18

		managePassTitle.text = managePassVM.title
		managePassDescription.text = managePassVM.description

		errorLabel.isHidden = true
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = UIFont.PinoStyle.mediumTitle3

		useFaceIDOptionStackView.axis = .horizontal
		useFaceIDOptionStackView.alignment = .center
		useFaceIDOptionStackView.isHidden = true

		useFaceIdAndErrorStackView.axis = .vertical
	}

	private func setupUnlockModeStyles() {
		managePassDescription.isHidden = true
		topInfoContainerView.alignment = .center
		spaceBetweenTopView.isHidden = false
		managePassTitle.font = .PinoStyle.mediumTitle2
	}

	private func setupFaceIDOptionStyles() {
		useFaceIDIcon.image = UIImage(named: managePassVM.useFaceIdIcon!)

		useFaceIDTitleLabel.text = managePassVM.useFaceIdTitle
		useFaceIDTitleLabel.font = .PinoStyle.mediumSubheadline

		useFaceIDSwitch.onTintColor = .Pino.green3

		useFaceIDOptionStackView.isHidden = false
	}

	@objc
	private func onUseFaceIDSwitchChange() {
		if useFaceIDSwitch.isOn {
			var faceIDAuthentication = BiometricAuthentication()
			faceIDAuthentication.evaluate { [weak self] in
				self?.onSuccessUnlockClosure()
			}
		}
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
		useFaceIDOptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
        useFaceIdAndErrorStackViewBottomConstraint = NSLayoutConstraint(item: useFaceIdAndErrorStackView, attribute: .bottom, relatedBy: .equal, toItem: layoutMarginsGuide, attribute: .bottom, multiplier: 1, constant: -useFaceIdAndErrorStackViewBottomConstant)
        addConstraint(useFaceIdAndErrorStackViewBottomConstraint)

		topInfoContainerView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.relative(.top, 85, to: topInfoContainerView, .bottom),
			.centerX(),
			.fixedHeight(20)
		)

		spaceBetweenTopView.pin(.fixedHeight(45))

		useFaceIdAndErrorStackView.pin(
			.horizontalEdges(padding: 16)
		)

		useFaceIDIcon.pin(.fixedWidth(24), .fixedHeight(24), .centerY())
		useFaceIDIconContainer.pin(.fixedWidth(24))
	}
    
    private func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        // Keyboard's animation duration
               let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

               // Keyboard's animation curve
               let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!

               // Change the constant
               if keyboardWillShow {
                   let safeAreaExists = (self.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
                   let keyboardOpenConstant = keyboardHeight - (safeAreaExists ? 20 : 0)
                   useFaceIdAndErrorStackViewBottomConstraint.constant = -keyboardOpenConstant
               } else {
                   useFaceIdAndErrorStackViewBottomConstraint.constant = -useFaceIdAndErrorStackViewBottomConstant
               }

               // Animate the view the same way the keyboard animates
               let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
                   // Update Constraints
                   self?.layoutIfNeeded()
               }

               // Perform the animation
               animator.startAnimation()
    }
    
    private func setFaceIdAndErrorStackViewConstraint() {
    
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
    
    @objc internal func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
    }
}
