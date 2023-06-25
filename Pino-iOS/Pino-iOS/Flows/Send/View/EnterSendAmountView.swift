//
//  EnterSendAmountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import UIKit

class EnterSendAmountView: UIView {
	// MARK: - Private Properties

	private let contentCardView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let maximumStackView = UIStackView()
	private let tokenStackView = UIStackView()
	private let amountTextFieldStackView = UIStackView()
	private let dollarSignLabel = UILabel()
	private let avgAmountLabel = UILabel()
	private let amountLabel = UILabel()
	private let amountInDollarLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let maxAmountInDollarLabel = UILabel()
	private let changeTokenView = TokenView()
	private let dollarFormatButton = UIButton()
	private let amountSpacerView = UIView()
	private let maxAmountSpacerView = UIView()
	private let continueButton = PinoButton(style: .deactive)
	private let maxAmountDollarSign = UILabel()
	private var changeSelectedToken: () -> Void
	private var nextButtonTapped: () -> Void
	private var enterAmountVM: EnterSendAmountViewModel

	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(
		enterAmountVM: EnterSendAmountViewModel,
		changeSelectedToken: @escaping (() -> Void),
		nextButtonTapped: @escaping (() -> Void)
	) {
		self.changeSelectedToken = changeSelectedToken
		self.nextButtonTapped = nextButtonTapped
		self.enterAmountVM = enterAmountVM
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
		addSubview(contentCardView)
		addSubview(continueButton)
		contentCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(amountStackView)
		contentStackView.addArrangedSubview(maximumStackView)
		amountStackView.addArrangedSubview(amountTextFieldStackView)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(tokenStackView)
		maximumStackView.addArrangedSubview(avgAmountLabel)
		maximumStackView.addArrangedSubview(amountLabel)
		maximumStackView.addArrangedSubview(amountInDollarLabel)
		maximumStackView.addArrangedSubview(maxAmountSpacerView)
		maximumStackView.addArrangedSubview(maxAmountStackView)
		tokenStackView.addArrangedSubview(dollarFormatButton)
		tokenStackView.addArrangedSubview(changeTokenView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountDollarSign)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)
		maxAmountStackView.addArrangedSubview(maxAmountInDollarLabel)
		amountTextFieldStackView.addArrangedSubview(dollarSignLabel)
		amountTextFieldStackView.addArrangedSubview(amountTextfield)

		continueButton.addAction(UIAction(handler: { _ in
			self.nextButtonTapped()
		}), for: .touchUpInside)

		dollarFormatButton.addAction(UIAction(handler: { _ in
			self.toggleDollarFormat()
		}), for: .touchUpInside)

		changeTokenView.tokenTapped = {
			self.changeSelectedToken()
		}

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOnAmountTextField))
		amountSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let putMAxAmountTapgesture = UITapGestureRecognizer(target: self, action: #selector(putMaxAmountInTextField))
		maxAmountStackView.addGestureRecognizer(putMAxAmountTapgesture)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyle() {
		maxAmountTitle.text = enterAmountVM.maxTitle
		maxAmountLabel.text = enterAmountVM.maxAmount
		maxAmountInDollarLabel.text = enterAmountVM.selectedToken.formattedHoldAmount
		continueButton.title = enterAmountVM.continueButtonTitle
		dollarSignLabel.text = enterAmountVM.dollarSign
		changeTokenView.tokenName = enterAmountVM.selectedToken.symbol
		maxAmountDollarSign.text = enterAmountVM.dollarSign

		if enterAmountVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = enterAmountVM.selectedToken.image
			avgAmountLabel.text = enterAmountVM.avgSign
			amountLabel.text = enterAmountVM.formattedAmount
			amountInDollarLabel.text = enterAmountVM.formattedAmountInDollar
			dollarFormatButton.isHidden = false
			amountLabel.alpha = 1
			amountInDollarLabel.alpha = 1
			avgAmountLabel.alpha = 1
		} else {
			changeTokenView.customTokenImage = enterAmountVM.selectedToken.customAssetImage
			dollarFormatButton.isHidden = true
			amountLabel.alpha = 0
			amountInDollarLabel.alpha = 0
			avgAmountLabel.alpha = 0
		}

		if enterAmountVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = enterAmountVM.selectedToken.image
		} else {
			changeTokenView.customTokenImage = enterAmountVM.selectedToken.customAssetImage
		}

		dollarFormatButton.setImage(UIImage(named: enterAmountVM.dollarIcon), for: .normal)

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: enterAmountVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		amountTextfield.font = .PinoStyle.semiboldTitle1
		avgAmountLabel.font = .PinoStyle.regularSubheadline
		amountLabel.font = .PinoStyle.regularSubheadline
		amountInDollarLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline
		maxAmountInDollarLabel.font = .PinoStyle.mediumSubheadline
		maxAmountDollarSign.font = .PinoStyle.mediumSubheadline
		dollarSignLabel.font = .PinoStyle.semiboldTitle1

		dollarFormatButton.tintColor = .Pino.primary
		avgAmountLabel.textColor = .Pino.secondaryLabel
		amountLabel.textColor = .Pino.secondaryLabel
		amountInDollarLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label
		maxAmountInDollarLabel.textColor = .Pino.label
		maxAmountDollarSign.textColor = .Pino.label
		dollarSignLabel.textColor = .Pino.gray2

		backgroundColor = .Pino.background
		contentCardView.backgroundColor = .Pino.secondaryBackground
		dollarFormatButton.backgroundColor = .Pino.background

		dollarFormatButton.layer.cornerRadius = 16
		contentCardView.layer.cornerRadius = 12

		contentStackView.axis = .vertical

		tokenStackView.alignment = .center

		tokenStackView.spacing = 6
		contentStackView.spacing = 22

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		dollarSignLabel.isHidden = true
		maxAmountDollarSign.isHidden = true
		maxAmountInDollarLabel.isHidden = true
		amountLabel.isHidden = true
		dollarFormatButton.isHidden = !enterAmountVM.selectedToken.isVerified

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping

		amountInDollarLabel.numberOfLines = 0
		amountInDollarLabel.lineBreakMode = .byCharWrapping

		enterAmountVM.selectedTokenChanged = {
			self.updateView()
		}
	}

	private func setupContstraint() {
		contentCardView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		contentStackView.pin(
			.verticalEdges(padding: 23),
			.horizontalEdges(padding: 14)
		)
		continueButton.pin(
			.horizontalEdges(padding: 16)
		)
		dollarFormatButton.pin(
			.fixedWidth(32),
			.fixedHeight(32)
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
		if enterAmountVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = enterAmountVM.selectedToken.image
			enterAmountVM.calculateAmount(amountTextfield.text ?? "0")
			amountLabel.text = enterAmountVM.formattedAmount
			amountInDollarLabel.text = enterAmountVM.formattedAmountInDollar
			dollarSignLabel.isHidden = !enterAmountVM.isDollarEnabled
			maxAmountDollarSign.isHidden = !enterAmountVM.isDollarEnabled
			maxAmountLabel.isHidden = enterAmountVM.isDollarEnabled
			maxAmountInDollarLabel.isHidden = !enterAmountVM.isDollarEnabled
			amountInDollarLabel.isHidden = enterAmountVM.isDollarEnabled
			amountLabel.isHidden = !enterAmountVM.isDollarEnabled
			dollarFormatButton.isHidden = false
			amountLabel.alpha = 1
			amountInDollarLabel.alpha = 1
			avgAmountLabel.alpha = 1
		} else {
			changeTokenView.customTokenImage = enterAmountVM.selectedToken.customAssetImage
			dollarFormatButton.isHidden = true
			dollarSignLabel.isHidden = true
			amountLabel.alpha = 0
			amountInDollarLabel.alpha = 0
			avgAmountLabel.alpha = 0
		}

		maxAmountLabel.text = enterAmountVM.maxAmount
		maxAmountInDollarLabel.text = enterAmountVM.selectedToken.formattedHoldAmount
		changeTokenView.tokenName = enterAmountVM.selectedToken.symbol
	}

	private func toggleDollarFormat() {
		UIView.animate(withDuration: 0.3) {
			if self.enterAmountVM.isDollarEnabled {
				self.enterAmountVM.isDollarEnabled = false
				self.dollarFormatButton.backgroundColor = .Pino.background
				self.dollarFormatButton.tintColor = .Pino.primary
			} else {
				self.enterAmountVM.isDollarEnabled = true
				self.dollarFormatButton.backgroundColor = .Pino.primary
				self.dollarFormatButton.tintColor = .Pino.green1
			}
			self.updateView()
		}
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if let amountText = textField.text, amountText != .emptyString {
			dollarSignLabel.textColor = .Pino.label
			updateAmount(enteredAmount: amountText)
		} else {
			dollarSignLabel.textColor = .Pino.gray2
			updateAmount(enteredAmount: "0")
		}
	}

	private func updateAmount(enteredAmount: String) {
		enterAmountVM.checkIfBalanceIsEnough(amount: enteredAmount) { amountStatus in
			switch amountStatus {
			case .isZero:
				continueButton.setTitle(enterAmountVM.continueButtonTitle, for: .normal)
				continueButton.style = .deactive
			case .isEnough:
				maxAmountTitle.textColor = .Pino.label
				maxAmountLabel.textColor = .Pino.label
				maxAmountInDollarLabel.textColor = .Pino.label
				maxAmountDollarSign.textColor = .Pino.label

				continueButton.setTitle(enterAmountVM.continueButtonTitle, for: .normal)
				continueButton.style = .active
			case .isNotEnough:
				maxAmountTitle.textColor = .Pino.orange
				maxAmountLabel.textColor = .Pino.orange
				maxAmountInDollarLabel.textColor = .Pino.orange
				maxAmountDollarSign.textColor = .Pino.orange
        
				continueButton.setTitle(enterAmountVM.insufficientAmountButtonTitle, for: .normal)
				continueButton.style = .deactive
			}
		}
		amountLabel.text = enterAmountVM.formattedAmount

		amountInDollarLabel.text = enterAmountVM.formattedAmountInDollar
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}

	}

	@objc
	private func putMaxAmountInTextField() {
		if enterAmountVM.selectedToken.id == AccountingEndpoint.ethID {
			#warning("calculate fee and remove fee from amount and then put it")
		} else {
			if enterAmountVM.isDollarEnabled {
				amountTextfield.text = enterAmountVM.selectedToken.formattedHoldAmount
			} else {
				amountTextfield.text = enterAmountVM.selectedToken.holdAmount.formattedAmountOf(type: .hold)
			}
		}
		amountTextfield.sendActions(for: .editingChanged)
	}

	@objc
	private func focusOnAmountTextField() {
		amountTextfield.becomeFirstResponder()
	}
}

extension EnterSendAmountView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		// Allow backspace
		if string.isEmpty {
			return true
		}

		// Check if the replacement string is a decimal point
		if string == "." {
			// Check if the existing text already contains a decimal point
			if let text = textField.text, text.contains(".") || text.isEmpty {
				// Disallow entering another decimal point
				return false
			}
		}

		// Allow decimal point and digits
		let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
		let replacementStringCharacterSet = CharacterSet(charactersIn: string)

		return allowedCharacters.isSuperset(of: replacementStringCharacterSet)
	}
}

// MARK: - Keyboard Functions

extension EnterSendAmountView {
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
