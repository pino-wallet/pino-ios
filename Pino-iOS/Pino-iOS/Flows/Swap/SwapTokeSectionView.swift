//
//  SwapTokeSectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/1/23.
//

import UIKit

class SwapTokenSectionView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let payAmountStackView = UIStackView()
	private let payEstimatedAmountStackView = UIStackView()
	private let payAmountLabel = UILabel()
	private let firstTokenMaxAmountStackView = UIStackView()
	private let firstTokenMaxAmountTitle = UILabel()
	private let firstTokenMaxAmountLabel = UILabel()
	private let changeTokenView = TokenView()
	private let amountSpacerView = UIView()
	private let maxAmountSpacerView = UIView()
	private let changeSelectedToken: () -> Void
	private let updateSwapAmount: (String) -> Void
	private let swapVM: EnterSendAmountViewModel
	private let hasMaxAmount: Bool

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(
		swapVM: EnterSendAmountViewModel,
		hasMaxAmount: Bool = true,
		changeSelectedToken: @escaping () -> Void,
		updateSwapAmount: @escaping (String) -> Void
	) {
		self.changeSelectedToken = changeSelectedToken
		self.updateSwapAmount = updateSwapAmount
		self.swapVM = swapVM
		self.hasMaxAmount = hasMaxAmount
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
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(payAmountStackView)
		contentStackView.addArrangedSubview(payEstimatedAmountStackView)
		payAmountStackView.addArrangedSubview(amountTextfield)
		payAmountStackView.addArrangedSubview(amountSpacerView)
		payAmountStackView.addArrangedSubview(changeTokenView)
		payEstimatedAmountStackView.addArrangedSubview(payAmountLabel)
		payEstimatedAmountStackView.addArrangedSubview(maxAmountSpacerView)
		payEstimatedAmountStackView.addArrangedSubview(firstTokenMaxAmountStackView)
		firstTokenMaxAmountStackView.addArrangedSubview(firstTokenMaxAmountTitle)
		firstTokenMaxAmountStackView.addArrangedSubview(firstTokenMaxAmountLabel)

		changeTokenView.tokenTapped = {
			self.changeSelectedToken()
		}

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
		amountSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let enterMaxAmountGesture = UITapGestureRecognizer(target: self, action: #selector(enterMaxAmount))
		firstTokenMaxAmountStackView.addGestureRecognizer(enterMaxAmountGesture)
	}

	private func setupStyle() {
		firstTokenMaxAmountTitle.text = swapVM.maxTitle
		firstTokenMaxAmountLabel.text = swapVM.maxHoldAmount
		changeTokenView.tokenName = swapVM.selectedToken.symbol

		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			payAmountLabel.text = swapVM.formattedAmount
			payAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			payAmountLabel.isHidden = true
		}

		firstTokenMaxAmountStackView.isHidden = !hasMaxAmount

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: swapVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		amountTextfield.font = .PinoStyle.semiboldTitle1
		payAmountLabel.font = .PinoStyle.regularSubheadline
		firstTokenMaxAmountTitle.font = .PinoStyle.regularSubheadline
		firstTokenMaxAmountLabel.font = .PinoStyle.mediumSubheadline

		payAmountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		firstTokenMaxAmountTitle.textColor = .Pino.label
		firstTokenMaxAmountLabel.textColor = .Pino.label

		contentStackView.axis = .vertical

		contentStackView.spacing = 22

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		payAmountLabel.numberOfLines = 0
		payAmountLabel.lineBreakMode = .byCharWrapping

		swapVM.selectedTokenChanged = {
			self.updateView()
		}
	}

	private func setupContstraint() {
		contentStackView.pin(
			.allEdges
		)
	}

	private func updateView() {
		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			swapVM.calculateAmount(amountTextfield.text ?? "0")
			payAmountLabel.text = swapVM.formattedAmount
			payAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			payAmountLabel.isHidden = true
		}
		firstTokenMaxAmountLabel.text = swapVM.maxHoldAmount
		changeTokenView.tokenName = swapVM.selectedToken.symbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if let amountText = textField.text, amountText != .emptyString {
			updateSwapAmount(amountText)
		} else {
			updateSwapAmount("0")
		}
	}

	@objc
	private func enterMaxAmount() {
		amountTextfield.text = swapVM.selectedToken.holdAmount.formattedAmountOf(type: .hold)
		amountTextfield.sendActions(for: .editingChanged)
	}

	// MARK: - Public Methods

	public func updateEstimatedAmount(isAmountEnough: Bool) {
		payAmountLabel.text = swapVM.formattedAmount
		if isAmountEnough {
			firstTokenMaxAmountTitle.textColor = .Pino.label
			firstTokenMaxAmountLabel.textColor = .Pino.label
		} else {
			firstTokenMaxAmountTitle.textColor = .Pino.orange
			firstTokenMaxAmountLabel.textColor = .Pino.orange
		}
	}

	@objc
	public func dissmisskeyBoard() {
		amountTextfield.endEditing(true)
	}

	@objc
	public func openKeyboard() {
		amountTextfield.becomeFirstResponder()
	}
}

extension SwapTokenSectionView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		guard let currentText = textField.text as NSString? else {
			return true
		}

		let updatedText = currentText.replacingCharacters(in: range, with: string)
		let pattern = "^(?!\\.)(?!.*\\..*\\.)([0-9]*)\\.?([0-9]*)$"
		let regex = try? NSRegularExpression(pattern: pattern, options: [])
		let range = NSRange(location: 0, length: updatedText.count)
		let isMatch = regex?.firstMatch(in: updatedText, options: [], range: range) != nil

		return isMatch
	}
}
