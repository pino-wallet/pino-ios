//
//  BorrowIncreaseAmountView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class BorrowIncreaseAmountView: UIView {
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
	private let healthScoreStackView = UIStackView()
	private let healthScoreSpacerView = UIView()
	private var nextButtonTapped: () -> Void
	private var borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel
	private var borrowIncreaseAmountHealthScore = AmountHealthScoreView()

	private var keyboardHeight: CGFloat = 320
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(borrowIncreaseAmountVM: BorrowIncreaseAmountViewModel, nextButtonTapped: @escaping () -> Void) {
		self.borrowIncreaseAmountVM = borrowIncreaseAmountVM
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
		contentStackView.addArrangedSubview(healthScoreStackView)
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
		healthScoreStackView.addArrangedSubview(healthScoreSpacerView)
		healthScoreStackView.addArrangedSubview(borrowIncreaseAmountHealthScore)

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
		maxAmountTitle.text = borrowIncreaseAmountVM.maxTitle
		maxAmountLabel.text = borrowIncreaseAmountVM.formattedMaxHoldAmount
		continueButton.title = borrowIncreaseAmountVM.continueButtonTitle
		tokenView.tokenName = borrowIncreaseAmountVM.tokenSymbol

		if borrowIncreaseAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = borrowIncreaseAmountVM.tokenImage
			amountLabel.text = borrowIncreaseAmountVM.dollarAmount
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = borrowIncreaseAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}

		if borrowIncreaseAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = borrowIncreaseAmountVM.selectedToken.image
		} else {
			tokenView.customTokenImage = borrowIncreaseAmountVM.selectedToken.customAssetImage
		}

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: borrowIncreaseAmountVM.textFieldPlaceHolder,
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

		healthScoreStackView.axis = .vertical
		healthScoreStackView.spacing = 16

		tokenStackView.alignment = .center

		tokenStackView.spacing = 6
		amountcontainerStackView.spacing = 22

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping

		borrowIncreaseAmountHealthScore.isHiddenInStackView = true
		borrowIncreaseAmountHealthScore.alpha = 0

		#warning("this values are temporary and should be deleted")
		borrowIncreaseAmountHealthScore.prevHealthScore = borrowIncreaseAmountVM.prevHealthScore
		borrowIncreaseAmountHealthScore.newHealthScore = borrowIncreaseAmountVM.newHealthScore
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
		if borrowIncreaseAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = borrowIncreaseAmountVM.selectedToken.image
			updateAmount(enteredAmount: amountTextfield.text ?? .emptyString)
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = borrowIncreaseAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}
		maxAmountLabel.text = borrowIncreaseAmountVM.formattedMaxHoldAmount
		tokenView.tokenName = borrowIncreaseAmountVM.selectedToken.symbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.last == "." || textField.text?.last == "," { return }
		if let amountText = textField.text, amountText != .emptyString {
			borrowIncreaseAmountVM.calculateDollarAmount(amountText)
			updateAmount(enteredAmount: amountText)
			animateAmountHealthScoreView(isHidden: false)
		} else {
			borrowIncreaseAmountVM.calculateDollarAmount(.emptyString)
			updateAmount(enteredAmount: .emptyString)
			animateAmountHealthScoreView(isHidden: true)
		}
	}

	private func animateAmountHealthScoreView(isHidden: Bool) {
		UIView.animate(withDuration: 0.2, animations: {
			self.borrowIncreaseAmountHealthScore.isHiddenInStackView = isHidden
			if isHidden {
				self.borrowIncreaseAmountHealthScore.alpha = 0
			} else {
				self.borrowIncreaseAmountHealthScore.alpha = 1
			}
		})
	}

	private func updateAmount(enteredAmount: String) {
		let amountStatus = borrowIncreaseAmountVM.checkBalanceStatus(amount: enteredAmount)
		switch amountStatus {
		case .isZero:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(borrowIncreaseAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .isEnough:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(borrowIncreaseAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
		case .isNotEnough:
			maxAmountTitle.textColor = .Pino.orange
			maxAmountLabel.textColor = .Pino.orange
			continueButton.setTitle(borrowIncreaseAmountVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
		}
		amountLabel.text = borrowIncreaseAmountVM.dollarAmount
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}
        
        // ACTIVATING continue button since in devnet we don't need validation
        // to check if there is balance
        if Environment.current == .devNet {
            continueButton.style = .active
        }
	}

	@objc
	private func putMaxAmountInTextField() {
		amountTextfield.text = borrowIncreaseAmountVM.maxHoldAmount.plainSevenDigitFormat
		amountLabel.text = borrowIncreaseAmountVM.dollarAmount
		animateAmountHealthScoreView(isHidden: false)

		if borrowIncreaseAmountVM.selectedToken.isEth {
			borrowIncreaseAmountVM.calculateDollarAmount(amountTextfield.text ?? .emptyString)
			maxAmountLabel.text = borrowIncreaseAmountVM.formattedMaxHoldAmount
		} else {
			borrowIncreaseAmountVM.tokenAmount = borrowIncreaseAmountVM.plainSevenDigitMaxHoldAmount
			borrowIncreaseAmountVM.dollarAmount = borrowIncreaseAmountVM.maxHoldAmountInDollars
		}

		maxAmountLabel.text = borrowIncreaseAmountVM.formattedMaxHoldAmount
		updateAmount(enteredAmount: amountTextfield.text!.trimmCurrency)
	}

	@objc
	private func focusOnAmountTextField() {
		amountTextfield.becomeFirstResponder()
	}
}

extension BorrowIncreaseAmountView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		textField.enteredNumberPatternIsValid(charactersRange: range, replacementString: string)
	}
}

// MARK: - Keyboard Functions

extension BorrowIncreaseAmountView {
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
