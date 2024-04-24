//
//  InvestDepositView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import Combine
import UIKit

class InvestDepositView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let investCardView = PinoContainerCard()
	private let investStackView = UIStackView()
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
	private let estimateSectionStackView = UIStackView()
	private let estimatedReturnCardView = PinoContainerCard()
	private let estimatedReturnStackView = UIStackView()
	private let estimatedReturnTitleLabel = UILabel()
	private let estimatedReturnLabel = UILabel()
	private let estimateSectionSpacerView = UIView()
	private let openPositionContainerView = UIView()
	private let openPositionErrorCard = UIView()
	private let openPositionErrorLabel = PinoLabel(style: .title, text: "")
	private let continueButton = PinoButton(style: .deactive)
	private let hapticManager = HapticManager()
	private var nextButtonTapped: () -> Void
	private var investVM: InvestViewModelProtocol

	private var keyboardHeight: CGFloat = 320
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)
	private var cancellable = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(
		investVM: InvestViewModelProtocol,
		nextButtonTapped: @escaping (() -> Void)
	) {
		self.investVM = investVM
		self.nextButtonTapped = nextButtonTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBinding()
		setupNotifications()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		addSubview(continueButton)
		contentStackView.addArrangedSubview(investCardView)
		contentStackView.addArrangedSubview(estimateSectionStackView)
		contentStackView.addArrangedSubview(openPositionContainerView)
		investCardView.addSubview(investStackView)
		investStackView.addArrangedSubview(amountStackView)
		investStackView.addArrangedSubview(maximumStackView)
		amountStackView.addArrangedSubview(amountTextfield)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(tokenView)
		maximumStackView.addArrangedSubview(amountLabel)
		maximumStackView.addArrangedSubview(maxAmountSpacerView)
		maximumStackView.addArrangedSubview(maxAmountStackView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)
		estimateSectionStackView.addArrangedSubview(estimateSectionSpacerView)
		estimateSectionStackView.addArrangedSubview(estimatedReturnCardView)
		estimatedReturnCardView.addSubview(estimatedReturnStackView)
		estimatedReturnStackView.addArrangedSubview(estimatedReturnTitleLabel)
		estimatedReturnStackView.addArrangedSubview(estimatedReturnLabel)
		openPositionContainerView.addSubview(openPositionErrorCard)
		openPositionErrorCard.addSubview(openPositionErrorLabel)

		continueButton.addAction(UIAction(handler: { _ in
			self.continueButton.style = .loading
			self.nextButtonTapped()
		}), for: .touchUpInside)

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(focusOnAmountTextField))
		amountSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let enterMaxAmountTapGesture = UITapGestureRecognizer(target: self, action: #selector(enterMaxAmount))
		maxAmountStackView.addGestureRecognizer(enterMaxAmountTapGesture)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyle() {
		maxAmountTitle.text = investVM.maxTitle
		maxAmountLabel.text = investVM.formattedMaxHoldAmount
		continueButton.title = investVM.continueButtonTitle
		tokenView.tokenName = investVM.selectedToken.symbol
		estimatedReturnTitleLabel.text = investVM.estimatedReturnTitle

		if investVM.selectedToken.isVerified {
			tokenView.tokenImageURL = investVM.selectedToken.image
			amountLabel.text = investVM.dollarAmount
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = investVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}

		if investVM.selectedToken.isVerified {
			tokenView.tokenImageURL = investVM.selectedToken.image
		} else {
			tokenView.customTokenImage = investVM.selectedToken.customAssetImage
		}

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: investVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		amountTextfield.font = .PinoStyle.semiboldTitle1
		amountLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline
		estimatedReturnTitleLabel.font = .PinoStyle.mediumBody
		estimatedReturnLabel.font = .PinoStyle.mediumBody
		openPositionErrorLabel.font = .PinoStyle.mediumCallout

		amountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label
		estimatedReturnTitleLabel.textColor = .Pino.label
		estimatedReturnLabel.textColor = .Pino.label
		openPositionErrorLabel.textColor = .Pino.label

		backgroundColor = .Pino.background
		investCardView.backgroundColor = .Pino.secondaryBackground
		openPositionErrorCard.backgroundColor = .Pino.lightRed

		investCardView.layer.cornerRadius = 12

		investStackView.axis = .vertical
		contentStackView.axis = .vertical
		estimateSectionStackView.axis = .vertical

		tokenStackView.alignment = .center

		estimateSectionStackView.spacing = 24
		tokenStackView.spacing = 6
		investStackView.spacing = 22

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping
		openPositionErrorLabel.numberOfLines = 0

		openPositionErrorCard.layer.cornerRadius = 12

		openPositionErrorCard.isHiddenInStackView = true
		estimatedReturnCardView.isHiddenInStackView = true
	}

	private func setupContstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		investStackView.pin(
			.verticalEdges(padding: 23),
			.horizontalEdges(padding: 14)
		)
		estimatedReturnStackView.pin(
			.verticalEdges(padding: 10),
			.horizontalEdges(padding: 14)
		)
		continueButton.pin(
			.horizontalEdges(padding: 16)
		)
		openPositionErrorLabel.pin(
			.horizontalEdges(padding: 16),
			.verticalEdges(padding: 14)
		)
		openPositionErrorCard.pin(
			.top(padding: 24),
			.bottom,
			.horizontalEdges
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
		NSLayoutConstraint.activate([
			amountSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 6),
		])
	}

	private func setupBinding() {
		guard let depositVM = investVM as? InvestDepositViewModel else {
			updateEstimatedReturn(nil)
			return
		}
		depositVM.$yearlyEstimatedReturn.sink { estimatedReturn in
			self.updateEstimatedReturn(estimatedReturn)
		}.store(in: &cancellable)

		depositVM.$hasOpenPosition.sink { hasOpenPosition in
			self.updateOpenPositionAlert(hasOpenPosition: hasOpenPosition, errorText: depositVM.positionErrorText)
			self.updateBalanceStatus(amount: depositVM.tokenAmount)
		}.store(in: &cancellable)
	}

	private func updateView() {
		if investVM.selectedToken.isVerified {
			tokenView.tokenImageURL = investVM.selectedToken.image
			updateAmount(enteredAmount: amountTextfield.text ?? .emptyString)
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = investVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}
		maxAmountLabel.text = investVM.formattedMaxHoldAmount
		tokenView.tokenName = investVM.selectedToken.symbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.last == "." || textField.text?.last == "," { return }
		if let amountText = textField.text, amountText != .emptyString {
			investVM.calculateDollarAmount(amountText)
			updateAmount(enteredAmount: amountText)
		} else {
			investVM.calculateDollarAmount(.emptyString)
			updateAmount(enteredAmount: .emptyString)
		}
	}

	private func updateAmount(enteredAmount: String) {
		updateBalanceStatus(amount: enteredAmount)
		amountLabel.text = investVM.dollarAmount
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}

		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			continueButton.style = .active
		}
	}

	private func updateBalanceStatus(amount: String) {
		let amountStatus = investVM.checkBalanceStatus(amount: amount)
		switch amountStatus {
		case .isZero:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(investVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .isEnough:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(investVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
		case .isNotEnough:
			maxAmountTitle.textColor = .Pino.orange
			maxAmountLabel.textColor = .Pino.orange
			continueButton.setTitle(investVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
		}
	}

	private func updateEstimatedReturn(_ estimatedReturn: String?) {
		UIView.animate(withDuration: 0.2) {
			if let estimatedReturn {
				self.estimatedReturnLabel.text = estimatedReturn
				self.estimatedReturnCardView.isHiddenInStackView = false
			} else {
				self.estimatedReturnCardView.isHiddenInStackView = true
			}
		}
	}

	@objc
	private func enterMaxAmount() {
		hapticManager.run(type: .selectionChanged)
		investVM.calculateDollarAmount(investVM.maxAvailableAmount)
		amountTextfield.text = investVM.maxAvailableAmount.formattedDecimalString
		updateAmount(enteredAmount: investVM.maxAvailableAmount.formattedDecimalString)
		amountTextfield
			.moveCursorToBeginning(textfieldWidth: amountTextfield.bounds.width + amountSpacerView.bounds.width)
	}

	@objc
	private func focusOnAmountTextField() {
		amountTextfield.becomeFirstResponder()
	}

	private func updateOpenPositionAlert(hasOpenPosition: Bool?, errorText: String) {
		if let hasOpenPosition, hasOpenPosition == true {
			openPositionErrorLabel.text = errorText
			openPositionErrorCard.isHiddenInStackView = false
			estimateSectionStackView.isHiddenInStackView = true
			continueButton.style = .deactive
		} else {
			openPositionErrorCard.isHiddenInStackView = true
		}
	}

	// MARK: Public Methods

	public func stopLoading() {
		continueButton.style = .active
	}
}

extension InvestDepositView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		textField.isNumber(charactersRange: range, replacementString: string)
	}
}

// MARK: - Keyboard Functions

extension InvestDepositView {
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
