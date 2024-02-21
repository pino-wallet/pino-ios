//
//  CollateralIncreaseAmountView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Combine
import UIKit

class CollateralIncreaseAmountView: UIView {
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
	private let errorContainerView = UIView()
	private let errorTextContainerView = UIView()
	private let errorTextLabel = PinoLabel(style: .title, text: "")
	private let healthScoreStackView = UIStackView()
	private let healthScoreSpacerView = UIView()
	private var collateralIncreaseAmountHealthScore = AmountHealthScoreView()
	private var nextButtonTapped: () -> Void
	private var collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel

	private var keyboardHeight: CGFloat = 320
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private let nextButtonBottomConstant = CGFloat(12)

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel, nextButtonTapped: @escaping () -> Void) {
		self.collateralIncreaseAmountVM = collateralIncreaseAmountVM
		self.nextButtonTapped = nextButtonTapped

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupNotifications()
		updateAmountStatus(enteredAmount: .emptyString)
		setupBindings()
		setupSkeletonLoading()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		addSubview(continueButton)
		errorTextContainerView.addSubview(errorTextLabel)
		errorContainerView.addSubview(errorTextContainerView)
		contentStackView.addArrangedSubview(amountCardView)
		contentStackView.addArrangedSubview(healthScoreStackView)
		contentStackView.addArrangedSubview(errorContainerView)
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
		healthScoreStackView.addArrangedSubview(collateralIncreaseAmountHealthScore)

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
		maxAmountTitle.text = collateralIncreaseAmountVM.maxTitle
		maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		continueButton.title = collateralIncreaseAmountVM.continueButtonTitle
		tokenView.tokenName = collateralIncreaseAmountVM.tokenSymbol

		if collateralIncreaseAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = collateralIncreaseAmountVM.tokenImage
			amountLabel.text = collateralIncreaseAmountVM.dollarAmount
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = collateralIncreaseAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: collateralIncreaseAmountVM.textFieldPlaceHolder,
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

		healthScoreStackView.axis = .vertical
		healthScoreStackView.spacing = 16

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		amountLabel.numberOfLines = 0
		amountLabel.lineBreakMode = .byCharWrapping

		errorTextContainerView.backgroundColor = .Pino.lightRed
		errorTextContainerView.layer.cornerRadius = 12
		errorTextContainerView.isHidden = true

		errorTextLabel.font = .PinoStyle.mediumCallout
		errorTextLabel.numberOfLines = 0

		collateralIncreaseAmountHealthScore.isHiddenInStackView = true
	}

	private func setupConstraints() {
		maxAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 38).isActive = true

		errorTextContainerView.pin(.horizontalEdges(padding: 0), .bottom(padding: 0), .top(padding: 24))
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		amountcontainerStackView.pin(
			.verticalEdges(padding: 23),
			.horizontalEdges(padding: 14)
		)
		errorTextLabel.pin(.horizontalEdges(padding: 16), .verticalEdges(padding: 14))
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
		NSLayoutConstraint.activate([
			amountSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 6),
		])
	}

	private func setupSkeletonLoading() {
		maxAmountLabel.isSkeletonable = true
	}

	private func animateAmountHealthScoreView(isHidden: Bool, completion: @escaping () -> Void = {}) {
		if collateralIncreaseAmountVM.collateralPageStatus != .openPositionError {
			UIView.animate(withDuration: 0.2, animations: {
				self.collateralIncreaseAmountHealthScore.isHiddenInStackView = isHidden
				if isHidden {
					self.collateralIncreaseAmountHealthScore.alpha = 0
				} else {
					self.collateralIncreaseAmountHealthScore.alpha = 1
				}
			}, completion: { _ in
				completion()
			})
		}
	}

	private func updateView() {
		if collateralIncreaseAmountVM.selectedToken.isVerified {
			tokenView.tokenImageURL = collateralIncreaseAmountVM.tokenImage
			updateAmountStatus(enteredAmount: amountTextfield.text ?? .emptyString)
			amountLabel.isHidden = false
		} else {
			tokenView.customTokenImage = collateralIncreaseAmountVM.selectedToken.customAssetImage
			amountLabel.isHidden = true
		}
		maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		tokenView.tokenName = collateralIncreaseAmountVM.tokenSymbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if textField.text?.last == "." || textField.text?.last == "," { return }
		if let amountText = textField.text, amountText != .emptyString {
			collateralIncreaseAmountVM.calculateDollarAmount(amountText)
			updateAmountStatus(enteredAmount: amountText)
			animateAmountHealthScoreView(isHidden: false)
			updateHealthScores()
		} else {
			collateralIncreaseAmountVM.calculateDollarAmount(.emptyString)
			updateAmountStatus(enteredAmount: .emptyString)
			animateAmountHealthScoreView(isHidden: true)
		}
	}

	private func updateAmountStatus(enteredAmount: String) {
		collateralIncreaseAmountVM.checkAmountStatus(amount: enteredAmount)

		amountLabel.text = collateralIncreaseAmountVM.dollarAmount
		if amountTextfield.text == .emptyString {
			continueButton.style = .deactive
		}
	}

	private func setupBindings() {
		collateralIncreaseAmountVM.$collateralPageStatus.sink { collateralPageStatus in
			self.updateViewWithStatus(collateralPageStatus: collateralPageStatus)
		}.store(in: &cancellables)
	}

	private func updateHealthScores() {
		collateralIncreaseAmountHealthScore.prevHealthScore = collateralIncreaseAmountVM.prevHealthScore
		collateralIncreaseAmountHealthScore.newHealthScore = collateralIncreaseAmountVM.newHealthScore
	}

	private func updateViewWithStatus(collateralPageStatus: CollateralPageStatus) {
		switch collateralPageStatus {
		case .isZero:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(collateralIncreaseAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
			errorTextContainerView.isHidden = true
			hideSkeletonView()
			maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		case .normal:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			continueButton.setTitle(collateralIncreaseAmountVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
			errorTextContainerView.isHidden = true
			hideSkeletonView()
			maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		case .isNotEnough:
			maxAmountTitle.textColor = .Pino.orange
			maxAmountLabel.textColor = .Pino.orange
			continueButton.setTitle(collateralIncreaseAmountVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
			errorTextContainerView.isHidden = true
			hideSkeletonView()
			maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		case .loading:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			errorTextContainerView.isHidden = true
			continueButton.setTitle(collateralIncreaseAmountVM.loadingButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .openPositionError:
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
			errorTextLabel.text = collateralIncreaseAmountVM.positionErrorText
			continueButton.setTitle(collateralIncreaseAmountVM.continueButtonTitle, for: .normal)
			hideSkeletonView()
			maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
			animateAmountHealthScoreView(isHidden: true, completion: {
				self.errorTextContainerView.isHidden = false
			})
			continueButton.style = .deactive
		}
		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Web3Network.current != .mainNet {
			continueButton.style = .active
		}
	}

	@objc
	private func putMaxAmountInTextField() {
		guard let maxHoldAmount = collateralIncreaseAmountVM.maxHoldAmount else {
			return
		}
		amountTextfield.text = maxHoldAmount.decimalString
		moveCursorToBeginning()
		animateAmountHealthScoreView(isHidden: false)

		if collateralIncreaseAmountVM.selectedToken.isEth {
			collateralIncreaseAmountVM.calculateDollarAmount(amountTextfield.text ?? .emptyString)
			maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		} else {
			collateralIncreaseAmountVM.tokenAmount = maxHoldAmount
				.decimalString
			collateralIncreaseAmountVM.dollarAmount = collateralIncreaseAmountVM.maxAmountInDollars
		}

		maxAmountLabel.text = collateralIncreaseAmountVM.formattedMaxHoldAmount
		updateAmountStatus(enteredAmount: amountTextfield.text!.trimmCurrency)
		collateralIncreaseAmountVM.calculateDollarAmount(amountTextfield.text!)
		updateHealthScores()
	}

	@objc
	private func focusOnAmountTextField() {
		amountTextfield.becomeFirstResponder()
	}
}

extension CollateralIncreaseAmountView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		textField.isNumber(charactersRange: range, replacementString: string)
	}
}

// MARK: - Keyboard Functions

extension CollateralIncreaseAmountView {
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

	func moveCursorToBeginning() {
		guard let textFieldText = amountTextfield.text else { return }
		let textAttributes = [NSAttributedString.Key.font: amountTextfield.font!]
		let textWidth = textFieldText.size(withAttributes: textAttributes).width

		if textWidth > (amountTextfield.bounds.width + amountSpacerView.bounds.width) {
			// Move the cursor to the beginning
			DispatchQueue.main.async {
				let beginning = self.amountTextfield.beginningOfDocument
				self.amountTextfield.selectedTextRange = self.amountTextfield.textRange(from: beginning, to: beginning)
			}
		}
	}
}
