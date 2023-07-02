//
//  SwapTokeSectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/1/23.
//

import Combine
import UIKit

class SwapTokenSectionView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let textFieldStackView = UIStackView()
	private let estimatedAmountStackView = UIStackView()
	private let estimatedAmountLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let changeTokenView = SwapTokenView()
	private let textFieldSpacerView = UIView()
	private let estimatedAmountSpacerView = UIView()
	private let changeSelectedToken: () -> Void
	private let updateBalanceStatus: (String) -> Void
	private let swapVM: SwapTokenViewModel
	private let hasMaxAmount: Bool
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let amountTextfield = UITextField()

	// MARK: - Initializers

	init(
		swapVM: SwapTokenViewModel,
		hasMaxAmount: Bool = true,
		changeSelectedToken: @escaping () -> Void,
		updateBalanceStatus: @escaping (String) -> Void
	) {
		self.changeSelectedToken = changeSelectedToken
		self.updateBalanceStatus = updateBalanceStatus
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
		contentStackView.addArrangedSubview(textFieldStackView)
		contentStackView.addArrangedSubview(estimatedAmountStackView)
		textFieldStackView.addArrangedSubview(amountTextfield)
		textFieldStackView.addArrangedSubview(textFieldSpacerView)
		textFieldStackView.addArrangedSubview(changeTokenView)
		estimatedAmountStackView.addArrangedSubview(estimatedAmountLabel)
		estimatedAmountStackView.addArrangedSubview(estimatedAmountSpacerView)
		estimatedAmountStackView.addArrangedSubview(maxAmountStackView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)

		changeTokenView.tokenTapped = {
			self.changeSelectedToken()
		}

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
		textFieldSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let enterMaxAmountGesture = UITapGestureRecognizer(target: self, action: #selector(enterMaxAmount))
		maxAmountStackView.addGestureRecognizer(enterMaxAmountGesture)
	}

	private func setupStyle() {
		maxAmountTitle.text = swapVM.maxTitle
		maxAmountLabel.text = swapVM.maxHoldAmount
		changeTokenView.tokenName = swapVM.selectedToken.symbol

		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			estimatedAmountLabel.text = swapVM.formattedAmount
			estimatedAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			estimatedAmountLabel.isHidden = true
		}

		maxAmountStackView.isHidden = !hasMaxAmount

		amountTextfield.attributedPlaceholder = NSAttributedString(
			string: swapVM.textFieldPlaceHolder,
			attributes: [.font: UIFont.PinoStyle.semiboldTitle1!, .foregroundColor: UIColor.Pino.gray2]
		)

		amountTextfield.font = .PinoStyle.semiboldTitle1
		estimatedAmountLabel.font = .PinoStyle.regularSubheadline
		maxAmountTitle.font = .PinoStyle.regularSubheadline
		maxAmountLabel.font = .PinoStyle.mediumSubheadline

		estimatedAmountLabel.textColor = .Pino.secondaryLabel
		amountTextfield.textColor = .Pino.label
		amountTextfield.tintColor = .Pino.primary
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label

		contentStackView.axis = .vertical

		contentStackView.spacing = 20

		amountTextfield.keyboardType = .decimalPad
		amountTextfield.delegate = self

		estimatedAmountLabel.numberOfLines = 0
		estimatedAmountLabel.lineBreakMode = .byCharWrapping

		swapVM.selectedTokenChanged = {
			self.updateView()
		}

		swapVM.swapAmountCalculated = { amount in
			self.amountTextfield.text = amount
			self.updateEstimatedAmount(enteredAmount: amount)
		}
	}

	private func setupContstraint() {
		contentStackView.pin(
			.verticalEdges,
			.horizontalEdges(padding: 14)
		)
	}

	private func updateView() {
		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			estimatedAmountLabel.text = swapVM.formattedAmount
			estimatedAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			estimatedAmountLabel.isHidden = true
		}
		maxAmountLabel.text = swapVM.maxHoldAmount
		changeTokenView.tokenName = swapVM.selectedToken.symbol
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		let amountText = amountTextfield.text ?? ""
		swapVM.amountUpdated(amountText)
		updateEstimatedAmount(enteredAmount: amountText)
	}

	private func updateEstimatedAmount(enteredAmount: String) {
		estimatedAmountLabel.text = swapVM.formattedAmount
		updateBalanceStatus(enteredAmount)
	}

	@objc
	private func enterMaxAmount() {
		amountTextfield.text = swapVM.selectedToken.holdAmount.formattedAmountOf(type: .hold)
		amountTextfield.sendActions(for: .editingChanged)
	}

	// MARK: - Public Methods

	public func updateAmountStatus(isAmountEnough: Bool) {
		if isAmountEnough {
			maxAmountTitle.textColor = .Pino.label
			maxAmountLabel.textColor = .Pino.label
		} else {
			maxAmountTitle.textColor = .Pino.orange
			maxAmountLabel.textColor = .Pino.orange
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

	public func fadeOutTokenView() {
		changeTokenView.alpha = 0
	}

	public func fadeInTokenView() {
		changeTokenView.alpha = 1
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

	func textFieldDidBeginEditing(_ textField: UITextField) {
		swapVM.isEditing = true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		swapVM.isEditing = false
	}
}
