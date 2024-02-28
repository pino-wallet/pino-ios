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
	private let selectAssetButton: PinoRightSideImageButton
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

	// MARK: - Initializers

	init(
		swapVM: SwapTokenViewModel,
		hasMaxAmount: Bool = true,
		changeSelectedToken: @escaping () -> Void
	) {
		self.changeSelectedToken = changeSelectedToken
		self.swapVM = swapVM
		self.hasMaxAmount = hasMaxAmount
		self.selectAssetButton = PinoRightSideImageButton(imageName: "chevron_down", style: .primary)
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
		textFieldStackView.addArrangedSubview(selectAssetButton)
		estimatedAmountStackView.addArrangedSubview(estimatedAmountLabel)
		estimatedAmountStackView.addArrangedSubview(estimatedAmountSpacerView)
		estimatedAmountStackView.addArrangedSubview(maxAmountStackView)
		maxAmountStackView.addArrangedSubview(maxAmountTitle)
		maxAmountStackView.addArrangedSubview(maxAmountLabel)

		changeTokenView.tokenViewDidSelect = {
			self.changeSelectedToken()
		}

		selectAssetButton.addAction(UIAction(handler: { _ in
			self.changeSelectedToken()
		}), for: .touchUpInside)

		amountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		let focusTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
		textFieldSpacerView.addGestureRecognizer(focusTextFieldTapGesture)
		let enterMaxAmountGesture = UITapGestureRecognizer(target: self, action: #selector(enterMaxAmount))
		maxAmountStackView.addGestureRecognizer(enterMaxAmountGesture)
	}

	private func setupStyle() {
		maxAmountTitle.text = swapVM.maxTitle
		maxAmountLabel.text = getMaxAmount(selectedToken: swapVM.selectedToken).sevenDigitFormat
		selectAssetButton.title = "Select asset"
		changeTokenView.tokenName = swapVM.selectedToken.symbol

		if swapVM.selectedToken.isVerified {
			changeTokenView.tokenImageURL = swapVM.selectedToken.image
			estimatedAmountLabel.text = swapVM.dollarAmount?.priceFormat
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
		selectAssetButton.corderRadius = 20

		amountTextfield.delegate = self
		swapVM.swapDelegate = self

		maxAmountStackView.isHidden = !hasMaxAmount
		selectAssetButton.isHiddenInStackView = true
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
			textFieldSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 6),
		])
		selectAssetButton.pin(
			.fixedHeight(40),
			.fixedWidth(140)
		)
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
		if hasMaxAmount {
			amountTextfield.text = swapVM.tokenAmount?.decimalString
		} else {
			amountTextfield.text = swapVM.tokenAmount?.sevenDigitFormatForFewAmounts
		}
		estimatedAmountLabel.text = swapVM.dollarAmount?.priceFormat
		maxAmountLabel.text = getMaxAmount(selectedToken: swapVM.selectedToken).sevenDigitFormat
		updateBalanceStatus()
	}

	private func updateEstimatedAmount(enteredAmount: BigNumber?) {
		swapVM.calculateDollarAmount(enteredAmount)
		estimatedAmountLabel.text = swapVM.dollarAmount?.priceFormat
		updateBalanceStatus()
		swapVM.amountUpdated(enteredAmount)
	}

	private func getMaxAmount(selectedToken: AssetViewModel) -> BigNumber {
		if selectedToken.isEth {
			let userDefManager = UserDefaultsManager(userDefaultKey: .gasLimits)
			let gasLimits: GasLimitsModel? = userDefManager.getValue()
			if let gasLimits {
				let maxEthAmount = selectedToken.holdAmountInDollor
				let gasLimitsManager = SwapGasLimitsManager(
					swapAmount: maxEthAmount,
					gasLimitsModel: gasLimits,
					isEth: true,
					provider: .paraswap
				)
				let maxAmount = selectedToken.holdAmount - gasLimitsManager.medianGasInfo.fee!
				if maxAmount.number > 0 {
					return maxAmount
				} else {
					return 0.bigNumber
				}
			} else {
				return selectedToken.holdAmount
			}
		} else {
			return selectedToken.holdAmount
		}
	}

	@objc
	private func enterMaxAmount() {
		openKeyboard()
		updateEstimatedAmount(enteredAmount: getMaxAmount(selectedToken: swapVM.selectedToken))
		updateAmountView()
		updateBalanceStatus()
		amountTextfield
			.moveCursorToBeginning(textfieldWidth: amountTextfield.bounds.width + textFieldSpacerView.bounds.width)
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
		maxAmountLabel.text = getMaxAmount(selectedToken: token).sevenDigitFormat
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

	public func lockTextField() {
		amountTextfield.isUserInteractionEnabled = false
	}

	public func unlockTextField() {
		amountTextfield.isUserInteractionEnabled = true
	}

	public func showSelectAssetButton() {
		selectAssetButton.isHiddenInStackView = false
		changeTokenView.isHiddenInStackView = true
	}

	public func hideSelectAssetButton() {
		selectAssetButton.isHiddenInStackView = true
		changeTokenView.isHiddenInStackView = false
	}

	public func hideDollarAmount() {
		estimatedAmountLabel.isHidden = true
	}

	public func showDollarAmount() {
		estimatedAmountLabel.isHidden = false
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
		unlockTextField()
	}

	func swapAmountCalculating() {
		showSkeletonView()
		amountTextfield.textColor = .Pino.gray3
		lockTextField()
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

	#warning("After testing swap should be deleted")
//	func textFieldDidEndEditing(_ textField: UITextField) {
//		swapVM.isEditing = false
//	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		if let inputAmount = textField.text, inputAmount.last != "." {
			let amountBigNum = BigNumber(numberWithDecimal: inputAmount)
			updateEstimatedAmount(enteredAmount: amountBigNum)
		}
	}
}
