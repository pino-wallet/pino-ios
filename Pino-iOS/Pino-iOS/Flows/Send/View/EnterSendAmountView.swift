//
//  EnterSendAmountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import Combine
import UIKit

class EnterSendAmountView: UIView {
	// MARK: Private Properties

	private let contentCardView = UIView()
	private let contentStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let maximumStackView = UIStackView()
	private let tokenStackView = UIStackView()
	private let amountTextFieldStackView = UIStackView()
	private let amountTextfield = UITextField()
	private let dollarSignLabel = UILabel()
	private let amountLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let changeTokenView = UIView()
	private let changeTokenStackView = UIStackView()
	private let tokenNameLabel = UILabel()
	private let tokenImageView = UIImageView()
	private let dollarFormatButton = UIButton()
	private let continueButton = PinoButton(style: .active)
	private var changeSelectedToken: () -> Void
	private var nextButtonTapped: () -> Void
	private var enterAmountVM: EnterSendAmountViewModel

	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

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
		amountStackView.addArrangedSubview(tokenStackView)
		maximumStackView.addArrangedSubview(amountLabel)
		maximumStackView.addArrangedSubview(maxAmountStackView)
		tokenStackView.addArrangedSubview(dollarFormatButton)
		tokenStackView.addArrangedSubview(changeTokenView)
		changeTokenView.addSubview(changeTokenStackView)
		changeTokenStackView.addArrangedSubview(tokenImageView)
		changeTokenStackView.addArrangedSubview(tokenNameLabel)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)
		amountTextFieldStackView.addArrangedSubview(dollarSignLabel)
		amountTextFieldStackView.addArrangedSubview(amountTextfield)

		continueButton.addAction(UIAction(handler: { _ in
			self.nextButtonTapped()
		}), for: .touchUpInside)

		dollarFormatButton.addAction(UIAction(handler: { _ in
			self.toggleDollarFormat()
		}), for: .touchUpInside)

		let changetokenGesture = UITapGestureRecognizer(target: self, action: #selector(changeToken))
		changeTokenView.addGestureRecognizer(changetokenGesture)

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
	}

	private func setupStyle() {
		tokenNameLabel.text = enterAmountVM.selectedToken.name
		amountLabel.text = enterAmountVM.formattedAmount
		maxAmountTitle.text = enterAmountVM.maxTitle
		maxAmountLabel.text = enterAmountVM.maxAmount
		continueButton.title = enterAmountVM.continueButtonTitle
		dollarSignLabel.text = "$"

		tokenImageView.kf.indicatorType = .activity
		tokenImageView.kf.setImage(with: enterAmountVM.selectedToken.image)

		dollarFormatButton.setImage(UIImage(named: enterAmountVM.dollarIcon), for: .normal)

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: enterAmountVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		tokenNameLabel.font = .PinoStyle.mediumCallout
		amountTextfield.font = .PinoStyle.semiboldTitle1
		amountLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline
		dollarSignLabel.font = .PinoStyle.semiboldTitle1

		dollarFormatButton.tintColor = .Pino.primary
		tokenNameLabel.textColor = .Pino.label
		amountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label
		dollarSignLabel.textColor = .Pino.gray2

		backgroundColor = .Pino.background
		contentCardView.backgroundColor = .Pino.secondaryBackground
		dollarFormatButton.backgroundColor = .Pino.background
		changeTokenView.backgroundColor = .Pino.clear

		dollarFormatButton.layer.cornerRadius = 16
		contentCardView.layer.cornerRadius = 12
		changeTokenView.layer.cornerRadius = 20

		changeTokenView.layer.borderColor = UIColor.Pino.background.cgColor
		changeTokenView.layer.borderWidth = 1

		contentStackView.axis = .vertical

		tokenStackView.alignment = .center

		changeTokenStackView.spacing = 4
		tokenStackView.spacing = 6
		contentStackView.spacing = 19

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		dollarSignLabel.isHidden = true

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
			.verticalEdges(padding: 22),
			.horizontalEdges(padding: 14)
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		dollarFormatButton.pin(
			.fixedWidth(32),
			.fixedHeight(32)
		)
		tokenImageView.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
		changeTokenStackView.pin(
			.verticalEdges(padding: 6),
			.horizontalEdges(padding: 8)
		)
	}

	private func updateView() {
		enterAmountVM.calculateAmount(amountTextfield.text ?? "0")
		tokenNameLabel.text = enterAmountVM.selectedToken.name
		amountLabel.text = enterAmountVM.formattedAmount
		maxAmountLabel.text = enterAmountVM.maxAmount

		tokenImageView.kf.indicatorType = .activity
		tokenImageView.kf.setImage(with: enterAmountVM.selectedToken.image)

		if enterAmountVM.isDollarEnabled {
			dollarSignLabel.isHidden = false
		} else {
			dollarSignLabel.isHidden = true
		}
	}

	@objc
	private func changeToken() {
		changeSelectedToken()
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
		if let amountText = textField.text, amountText != "" {
			dollarSignLabel.textColor = .Pino.label
			updateAmount(enteredAmount: amountText)
		} else {
			dollarSignLabel.textColor = .Pino.gray2
			updateAmount(enteredAmount: "0")
		}
	}

	private func updateAmount(enteredAmount: String) {
		enterAmountVM.calculateAmount(enteredAmount)
		amountLabel.text = enterAmountVM.formattedAmount
	}

	@objc
	private func dissmisskeyBoard() {
		amountTextfield.endEditing(true)
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
			if let text = textField.text, text.contains(".") {
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
