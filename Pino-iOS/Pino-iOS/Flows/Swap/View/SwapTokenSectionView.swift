//
//  SwapTokenSectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation
import UIKit

class SwapTokenSectionView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let textFieldStackView = UIStackView()
	private let estimatedAmountStackView = UIStackView()
	private let amountTextfield = UITextField()
	private let estimatedAmountLabel = UILabel()
	private let maxAmountStackView = UIStackView()
	private let maxAmountTitle = UILabel()
	private let maxAmountLabel = UILabel()
	private let changeTokenView = SwapTokenView()
	private let textFieldSpacerView = UIView()
	private let estimatedAmountSpacerView = UIView()
	private let changeSelectedToken: () -> Void
	private let swapVM: SwapTokenViewModel
	private let hasMaxAmount: Bool
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var balanceStatus: AmountStatus = .isZero
	public var balanceStatusDidChange: ((AmountStatus) -> Void)?
	public var editingBegin: (() -> Void)?
	public var isCalculating = false

	// MARK: - Initializers

	init(
		swapVM: SwapTokenViewModel,
		hasMaxAmount: Bool = true,
		changeSelectedToken: @escaping () -> Void
	) {
		self.changeSelectedToken = changeSelectedToken
		self.swapVM = swapVM
		self.hasMaxAmount = hasMaxAmount
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBinding()
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

		changeTokenView.tokenViewDidSelect = {
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
			estimatedAmountLabel.text = swapVM.dollarAmount
			estimatedAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			estimatedAmountLabel.isHidden = true
		}

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
		estimatedAmountLabel.numberOfLines = 0
		estimatedAmountLabel.lineBreakMode = .byCharWrapping
		estimatedAmountLabel.isSkeletonable = true

		amountTextfield.delegate = self
		swapVM.swapDelegate = self

		maxAmountStackView.isHidden = !hasMaxAmount
	}

	private func setupContstraint() {
		contentStackView.pin(
			.verticalEdges,
			.horizontalEdges(padding: 14)
		)
		NSLayoutConstraint.activate([
			estimatedAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
			changeTokenView.widthAnchor.constraint(greaterThanOrEqualToConstant: 101),
			changeTokenView.widthAnchor.constraint(lessThanOrEqualToConstant: 130),
		])
	}

	private func setupBinding() {
		swapVM.$selectedToken.sink { selectedToken in
			self.updateMaxAmount(token: selectedToken)
			self.updateBalanceStatus()
		}.store(in: &cancellables)
	}

	private func updateView() {
		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			estimatedAmountLabel.isHidden = false
		} else {
			changeTokenView.customTokenImage = swapVM.selectedToken.customAssetImage
			estimatedAmountLabel.isHidden = true
		}
		changeTokenView.tokenName = swapVM.selectedToken.symbol
		updateAmountView()
	}

	private func updateAmountView() {
		amountTextfield.text = swapVM.tokenAmount
		estimatedAmountLabel.text = swapVM.dollarAmount
		maxAmountLabel.text = swapVM.maxHoldAmount
		updateBalanceStatus()
	}

	private func updateEstimatedAmount(enteredAmount: String) {
		swapVM.amountUpdated(enteredAmount)
		estimatedAmountLabel.text = swapVM.dollarAmount
		updateBalanceStatus()
	}

	@objc
	private func enterMaxAmount() {
		openKeyboard()
		amountTextfield.text = swapVM.selectedToken.holdAmount.sevenDigitFormat
		amountTextfield.sendActions(for: .editingChanged)
	}

	fileprivate func extractedFunc(_ balanceStatus: AmountStatus) {
		switch balanceStatus {
		case .isEnough, .isZero:
			hideBalanceError()
		case .isNotEnough:
			showBalanceError()
		}
	}

	private func updateBalanceStatus(token: AssetViewModel? = nil) {
		guard let balanceStatusDidChange else { return }
		let selectedToken = token ?? swapVM.selectedToken
		balanceStatus = swapVM.checkBalanceStatus(token: selectedToken)
		balanceStatusDidChange(balanceStatus)
		extractedFunc(balanceStatus)
	}

	private func showBalanceError() {
		maxAmountTitle.textColor = .Pino.orange
		maxAmountLabel.textColor = .Pino.orange
	}

	private func hideBalanceError() {
		maxAmountTitle.textColor = .Pino.label
		maxAmountLabel.textColor = .Pino.label
	}

	private func updateMaxAmount(token: AssetViewModel) {
		swapVM.maxHoldAmount = token.amount
		maxAmountLabel.text = swapVM.maxHoldAmount
	}

	// MARK: - Public Methods

	@objc
	public func dissmisskeyBoard() {
		amountTextfield.endEditing(true)
	}

	@objc
	public func openKeyboard() {
		amountTextfield.becomeFirstResponder()
	}
}

extension SwapTokenSectionView: SwapDelegate {
	func selectedTokenDidChange() {
		updateView()
	}

	func swapAmountDidCalculate() {
		hideSkeletonView()
		amountTextfield.textColor = .Pino.label
		updateAmountView()
		isCalculating = false
		amountTextfield.isUserInteractionEnabled = true
	}

	func swapAmountCalculating() {
		showSkeletonView()
		amountTextfield.textColor = .Pino.gray3
		isCalculating = true
		amountTextfield.isUserInteractionEnabled = false
	}
}

extension SwapTokenSectionView: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		textField.isNumber(charactersRange: range, replacementString: string)
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		guard let editingBegin else { return }
		editingBegin()
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		swapVM.isEditing = false
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		updateEstimatedAmount(enteredAmount: amountTextfield.text ?? "")
	}
}
