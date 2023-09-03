//
//  RepayAmountView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class RepayAmountView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let amountCardView = PinoContainerCard()
	private let amountcontainerStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let maximumStackView = UIStackView()
	private let tokenStackView = UIStackView()
	private let amountLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let tokenView = TokenView()
	private let amountSpacerView = UIView()
	private let maxAmountSpacerView = UIView()
	private let continueButton = PinoButton(style: .deactive)
	private var nextButtonTapped: () -> Void
	private var repayAmountVM: RepayAmountViewModel

	private var keyboardHeight: CGFloat = 320
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(repayAmountVM: RepayAmountViewModel, nextButtonTapped: @escaping () -> Void) {
		self.repayAmountVM = repayAmountVM
		self.nextButtonTapped = nextButtonTapped

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupNotifications()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		addSubview(continueButton)
		contentStackView.addArrangedSubview(amountCardView)
		amountCardView.addSubview(amountcontainerStackView)
		amountcontainerStackView.addArrangedSubview(amountStackView)
		amountcontainerStackView.addArrangedSubview(maximumStackView)
		amountStackView.addArrangedSubview(amountTextfield)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(tokenView)
		maximumStackView.addArrangedSubview(amountLabel)
		maximumStackView.addArrangedSubview(maxAmountSpacerView)
		maximumStackView.addArrangedSubview(maxAmountStackView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)

		continueButton.addAction(UIAction(handler: { _ in
			self.nextButtonTapped()
		}), for: .touchUpInside)

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOnAmountTextField))
		amountSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let putMAxAmountTapgesture = UITapGestureRecognizer(target: self, action: #selector(putMaxAmountInTextField))
		maxAmountStackView.addGestureRecognizer(putMAxAmountTapgesture)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyles() {
		maxAmountTitle.text = repayAmountVM.maxTitle
		maxAmountLabel.text = repayAmountVM.formattedMaxHoldAmount
		continueButton.title = repayAmountVM.continueButtonTitle
		tokenView.tokenName = repayAmountVM.selectedToken.symbol

		if repayAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = repayAmountVM.selectedToken.image
			amountLabel.text = repayAmountVM.dollarAmount
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = repayAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}

		if repayAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = repayAmountVM.selectedToken.image
		} else {
			tokenView.customTokenImage = repayAmountVM.selectedToken.customAssetImage
		}

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: repayAmountVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		amountTextfield.font = .PinoStyle.semiboldTitle1
		amountLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline

		amountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label

		backgroundColor = .Pino.background
		amountCardView.backgroundColor = .Pino.secondaryBackground

		amountCardView.layer.cornerRadius = 12

		amountcontainerStackView.axis = .vertical
		contentStackView.axis = .vertical

		tokenStackView.alignment = .center

		tokenStackView.spacing = 6
		amountcontainerStackView.spacing = 22

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping
	}

	private func setupConstraints() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		amountcontainerStackView.pin(
			.verticalEdges(padding: 23),
			.horizontalEdges(padding: 14)
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

	private func updateView() {
		if repayAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = repayAmountVM.selectedToken.image
			updateAmount(enteredAmount: amountTextfield.text ?? .emptyString)
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = repayAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}
		maxAmountLabel.text = repayAmountVM.formattedMaxHoldAmount
		tokenView.tokenName = repayAmountVM.selectedToken.symbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.last == "." || textField.text?.last == "," { return }
		if let amountText = textField.text, amountText != .emptyString {
			repayAmountVM.calculateDollarAmount(amountText)
			updateAmount(enteredAmount: amountText)
		} else {
			repayAmountVM.calculateDollarAmount(.emptyString)
			updateAmount(enteredAmount: .emptyString)
		}
	}

	private func updateAmount(enteredAmount: String) {
		let amountStatus = repayAmountVM.checkBalanceStatus(amount: enteredAmount)
		switch amountStatus {
		case .isZero:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(repayAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .isEnough:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(repayAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
		case .isNotEnough:
			maxAmountTitle.textColor = .Pino.orange
			maxAmountLabel.textColor = .Pino.orange
			continueButton.setTitle(repayAmountVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
		}
		amountLabel.text = repayAmountVM.dollarAmount
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}
	}

	@objc
	private func putMaxAmountInTextField() {
		amountTextfield.text = repayAmountVM.maxHoldAmount.sevenDigitFormat
		amountLabel.text = repayAmountVM.dollarAmount

		if repayAmountVM.selectedToken.isEth {
			repayAmountVM.calculateDollarAmount(amountTextfield.text ?? .emptyString)
			maxAmountLabel.text = repayAmountVM.formattedMaxHoldAmount
		} else {
			repayAmountVM.maxHoldAmount = repayAmountVM.selectedToken.holdAmount
			repayAmountVM.tokenAmount = repayAmountVM.selectedToken.holdAmount.sevenDigitFormat
			repayAmountVM.dollarAmount = repayAmountVM.selectedToken.holdAmountInDollor.priceFormat
		}

		maxAmountLabel.text = repayAmountVM.formattedMaxHoldAmount
		updateAmount(enteredAmount: amountTextfield.text!.trimmCurrency)
	}

	@objc
	private func focusOnAmountTextField() {
		amountTextfield.becomeFirstResponder()
	}
}

extension RepayAmountView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		textField.enteredNumberPatternIsValid(charactersRange: range, replacementString: string)
	}
}

// MARK: - Keyboard Functions

extension RepayAmountView {
	// MARK: - Private Methods

	@objc
	private func dissmisskeyBoard() {
		amountTextfield.endEditing(true)
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
