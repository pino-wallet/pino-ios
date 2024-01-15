//
//  EnterSendAmountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import Combine
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
	private let amountLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let maxAmountInDollarLabel = UILabel()
	private let changeTokenView = TokenView()
	private let dollarFormatButton = UIButton()
	private let amountSpacerView = UIView()
	private let maxAmountSpacerView = UIView()
	private let continueButton = PinoButton(style: .deactive)
	private var changeSelectedToken: () -> Void
	private var nextButtonTapped: () -> Void
	private var enterAmountVM: EnterSendAmountViewModel

	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)
	private var cancellable = Set<AnyCancellable>()

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
		setupBindings()
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
		maximumStackView.addArrangedSubview(amountLabel)
		maximumStackView.addArrangedSubview(maxAmountSpacerView)
		maximumStackView.addArrangedSubview(maxAmountStackView)
		tokenStackView.addArrangedSubview(dollarFormatButton)
		tokenStackView.addArrangedSubview(changeTokenView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
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

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOnAmountTextField))
		amountSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let putMAxAmountTapgesture = UITapGestureRecognizer(target: self, action: #selector(putMaxAmountInTextField))
		maxAmountStackView.addGestureRecognizer(putMAxAmountTapgesture)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyle() {
		maxAmountTitle.text = enterAmountVM.maxTitle
		maxAmountLabel.text = enterAmountVM.formattedMaxHoldAmount
		maxAmountInDollarLabel.text = enterAmountVM.formattedMaxAmountInDollar
		continueButton.title = enterAmountVM.continueButtonTitle
		dollarSignLabel.text = enterAmountVM.dollarSign
		changeTokenView.tokenName = enterAmountVM.selectedToken.symbol

		if enterAmountVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = enterAmountVM.selectedToken.image
			amountLabel.text = enterAmountVM.formattedAmount
			dollarFormatButton.isHidden = false
			amountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = enterAmountVM.selectedToken.customAssetImage
			dollarFormatButton.isHidden = true
			amountLabel.isHidden = true
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
		amountLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline
		maxAmountInDollarLabel.font = .PinoStyle.mediumSubheadline
		dollarSignLabel.font = .PinoStyle.semiboldTitle1

		dollarFormatButton.tintColor = .Pino.primary
		amountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label
		maxAmountInDollarLabel.textColor = .Pino.label
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
		maxAmountInDollarLabel.isHidden = true
		dollarFormatButton.isHidden = !enterAmountVM.selectedToken.isVerified

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping

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

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee
			.compactMap { $0 }
			.sink { gasInfo in
				if self.enterAmountVM.selectedToken.isEth {
					self.enterAmountVM.updateEthMaxAmount()
					self.enterAmountVM.calculateAmount(self.amountTextfield.text ?? .emptyString)
					self.updateAmount(enteredAmount: self.amountTextfield.text ?? .emptyString)
					self.maxAmountLabel.text = self.enterAmountVM.formattedMaxHoldAmount
					self.maxAmountInDollarLabel.text = self.enterAmountVM.formattedMaxAmountInDollar
				}
			}.store(in: &cancellable)
	}

	private func updateView() {
		if enterAmountVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = enterAmountVM.selectedToken.image
			updateAmount(enteredAmount: amountTextfield.text ?? .emptyString)
			dollarFormatButton.isHidden = false
			amountLabel.isHidden = false
			applyDollarFormatChanges()
		} else {
			changeTokenView.customTokenImage = enterAmountVM.selectedToken.customAssetImage
			dollarFormatButton.isHidden = true
			dollarSignLabel.isHidden = true
			amountLabel.isHidden = true
		}
		maxAmountLabel.text = enterAmountVM.formattedMaxHoldAmount
		maxAmountInDollarLabel.text = enterAmountVM.formattedMaxAmountInDollar
		changeTokenView.tokenName = enterAmountVM.selectedToken.symbol
	}

	private func applyDollarFormatChanges() {
		dollarSignLabel.isHidden = !enterAmountVM.isDollarEnabled
		maxAmountLabel.isHidden = enterAmountVM.isDollarEnabled
		maxAmountInDollarLabel.isHidden = !enterAmountVM.isDollarEnabled
		dollarSignLabel.textColor = .Pino.gray2
	}

	private func toggleDollarFormat() {
		UIView.animate(withDuration: 0.3) {
			if self.enterAmountVM.isDollarEnabled {
				self.enterAmountVM.isDollarEnabled = false
				self.dollarFormatButton.backgroundColor = .Pino.background
				self.dollarFormatButton.tintColor = .Pino.primary
				if let tokenAmount = self.enterAmountVM.tokenAmount {
					self.amountTextfield.text = tokenAmount.sevenDigitFormat
					self.enterAmountVM.calculateAmount(tokenAmount.decimalString)
				}
			} else {
				self.enterAmountVM.isDollarEnabled = true
				self.dollarFormatButton.backgroundColor = .Pino.primary
				self.dollarFormatButton.tintColor = .Pino.green1
				if let dollarAmount = self.enterAmountVM.dollarAmount {
					self.amountTextfield.text = dollarAmount.priceFormat.trimmCurrency
					self.enterAmountVM.calculateAmount(dollarAmount.decimalString)
				}
			}
			self.updateAmount(enteredAmount: self.amountTextfield.text ?? .emptyString)
			self.applyDollarFormatChanges()
		}
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.last == "." || textField.text?.last == "," { return }
		if let amountText = textField.text, amountText != .emptyString {
			dollarSignLabel.textColor = .Pino.label
			enterAmountVM.calculateAmount(amountText)
			updateAmount(enteredAmount: amountText)
		} else {
			dollarSignLabel.textColor = .Pino.gray2
			enterAmountVM.calculateAmount(.emptyString)
			updateAmount(enteredAmount: .emptyString)
		}
	}

	private func updateAmount(enteredAmount: String) {
		enterAmountVM.checkIfBalanceIsEnough(amount: enteredAmount) { amountStatus in
			switch amountStatus {
			case .isZero:
				maxAmountTitle.textColor = .Pino.label
				maxAmountLabel.textColor = .Pino.label
				maxAmountInDollarLabel.textColor = .Pino.label

				continueButton.setTitle(enterAmountVM.continueButtonTitle, for: .normal)
				continueButton.style = .deactive
			case .isEnough:
				maxAmountTitle.textColor = .Pino.label
				maxAmountLabel.textColor = .Pino.label
				maxAmountInDollarLabel.textColor = .Pino.label

				continueButton.setTitle(enterAmountVM.continueButtonTitle, for: .normal)
				continueButton.style = .active
			case .isNotEnough:
				maxAmountTitle.textColor = .Pino.orange
				maxAmountLabel.textColor = .Pino.orange
				maxAmountInDollarLabel.textColor = .Pino.orange

				continueButton.setTitle(enterAmountVM.insufficientAmountButtonTitle, for: .normal)
				continueButton.style = .deactive
			}
		}
		amountLabel.text = enterAmountVM.formattedAmount
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}
		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			continueButton.style = .active
		}
	}

	@objc
	private func putMaxAmountInTextField() {
		if enterAmountVM.isDollarEnabled {
			amountTextfield.text = enterAmountVM.maxAmountInDollar.priceFormat.trimmCurrency
			amountLabel.text = enterAmountVM.formattedMaxHoldAmount
		} else {
			amountTextfield.text = enterAmountVM.maxHoldAmount.sevenDigitFormat
			amountLabel.text = enterAmountVM.formattedMaxAmountInDollar
		}

		if enterAmountVM.selectedToken.isEth {
			enterAmountVM.calculateAmount(amountTextfield.text ?? .emptyString)
			maxAmountLabel.text = enterAmountVM.formattedMaxHoldAmount
			maxAmountInDollarLabel.text = enterAmountVM.formattedMaxAmountInDollar
		} else {
			enterAmountVM.maxHoldAmount = enterAmountVM.selectedToken.holdAmount
			enterAmountVM.maxAmountInDollar = enterAmountVM.selectedToken.holdAmountInDollor
			enterAmountVM.tokenAmount = enterAmountVM.selectedToken.holdAmount
			enterAmountVM.dollarAmount = enterAmountVM.selectedToken.holdAmountInDollor
		}

		maxAmountInDollarLabel.text = enterAmountVM.formattedMaxAmountInDollar
		maxAmountLabel.text = enterAmountVM.formattedMaxHoldAmount
		updateAmount(enteredAmount: amountTextfield.text!.trimmCurrency)
		dollarSignLabel.textColor = .Pino.label
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
		textField.isNumber(charactersRange: range, replacementString: string)
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
