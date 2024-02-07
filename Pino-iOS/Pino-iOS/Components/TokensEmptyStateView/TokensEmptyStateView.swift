//
//  ManageAssetEmptyStateView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/14/24.
//

import Foundation
import UIKit

class TokensEmptyStateView: UIView {
	// MARK: - Closures

	private var onActionButton: () -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let textStackView = UIStackView()
	private let descriptionStackView = UIStackView()
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let actionLabel = UILabel()
    private var keyboardHeight: CGFloat = 320
    private var mainStackViewCenterConstraint: NSLayoutConstraint!
    private var mainStackViewBottomConstraint: NSLayoutConstraint!
    private var onDismissKeyboard: () -> Void
	private var tokensEmptyStateTexts: TokensEmptyStateTexts {
		didSet {
			updateUI()
		}
	}

	// MARK: - Initializers

    init(tokensEmptyStateTexts: TokensEmptyStateTexts, onImportButton: @escaping () -> Void = {}, onDismissKeyboard: @escaping () -> Void) {
		self.tokensEmptyStateTexts = tokensEmptyStateTexts
		self.onActionButton = onImportButton
        self.onDismissKeyboard = onDismissKeyboard

		super.init(frame: .zero)

		setupView()
		setupStyles()
        setupNotifications()
		setupConstraints()
		updateUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let onImportTapGesture = UITapGestureRecognizer(target: self, action: #selector(onActionTap))
		actionLabel.addGestureRecognizer(onImportTapGesture)
		actionLabel.isUserInteractionEnabled = true
        
        let keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard))
        addGestureRecognizer(keyboardDismissTapGesture)
        isUserInteractionEnabled = true

		mainStackView.addArrangedSubview(titleImageView)
		mainStackView.addArrangedSubview(textStackView)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionStackView)

		descriptionStackView.addArrangedSubview(descriptionLabel)
		descriptionStackView.addArrangedSubview(actionLabel)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.alignment = .center

		textStackView.axis = .vertical
		textStackView.spacing = 8
		textStackView.alignment = .center

		descriptionStackView.axis = .horizontal
		descriptionStackView.spacing = 2
		descriptionStackView.alignment = .center

		titleLabel.font = .PinoStyle.semiboldTitle2

		descriptionLabel.font = .PinoStyle.mediumBody

		actionLabel.textColor = .Pino.primary
		actionLabel.font = .PinoStyle.boldBody
	}

	private func updateUI() {
		titleImageView.image = UIImage(named: tokensEmptyStateTexts.titleImageName)

		titleLabel.text = tokensEmptyStateTexts.titleText

		descriptionLabel.text = tokensEmptyStateTexts.descriptionText

		actionLabel.text = tokensEmptyStateTexts.buttonTitle

		if tokensEmptyStateTexts.buttonTitle != nil {
			actionLabel.isHidden = false
		} else {
			actionLabel.isHidden = true
		}
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		descriptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        mainStackViewCenterConstraint = mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        mainStackViewCenterConstraint.isActive = true
        mainStackViewBottomConstraint = mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        

		mainStackView.pin(.horizontalEdges(padding: 16))
		titleImageView.pin(.fixedWidth(56), .fixedHeight(56))
	}

	@objc
	private func onActionTap() {
		onActionButton()
	}
    
    @objc
    private func dissmisskeyBoard() {
        onDismissKeyboard()
    }
}


// MARK: - Keyboard Functions

extension TokensEmptyStateView {
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
            let keyboardOpenConstant = keyboardHeight - (safeAreaExists ? 20 : 0)
            mainStackViewBottomConstraint.constant = -(keyboardOpenConstant + 130)
            mainStackViewBottomConstraint.isActive = true
            mainStackViewCenterConstraint.isActive = false
        } else {
            mainStackViewBottomConstraint.isActive = false
            mainStackViewCenterConstraint.isActive = true
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
