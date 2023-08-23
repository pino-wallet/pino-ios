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

    private let contentCardView = PinoContainerCard()
    private let contentStackView = UIStackView()
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
    private var nextButtonTapped: () -> Void
    private var investVM: InvestDepositViewModel

    private var keyboardHeight: CGFloat = 320
    private var nextButtonBottomConstraint: NSLayoutConstraint!
    private let nextButtonBottomConstant = CGFloat(12)
    private var cancellable = Set<AnyCancellable>()

    // MARK: - Public Properties

    public let amountTextfield = UITextField()

    // MARK: - Initializers

    init(
        investVM: InvestDepositViewModel,
        nextButtonTapped: @escaping (() -> Void)
    ) {
        self.investVM = investVM
        self.nextButtonTapped = nextButtonTapped
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
        amountStackView.addArrangedSubview(amountTextfield)
        amountStackView.addArrangedSubview(amountSpacerView)
        amountStackView.addArrangedSubview(tokenView)
        maximumStackView.addArrangedSubview(amountLabel)
        maximumStackView.addArrangedSubview(maxAmountSpacerView)
        maximumStackView.addArrangedSubview(maxAmountStackView)
        maxAmountStackView.addArrangedSubview(maxAmountTitle)
        maxAmountStackView.addArrangedSubview(maxAmountLabel)

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

    private func setupStyle() {
        maxAmountTitle.text = investVM.maxTitle
        maxAmountLabel.text = investVM.formattedMaxHoldAmount
        continueButton.title = investVM.continueButtonTitle
        tokenView.tokenName = investVM.selectedToken.symbol

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

        amountLabel.textColor = .Pino.secondaryLabel
        amountTextfield.textColor = .Pino.label
        amountTextfield.tintColor = .Pino.primary
        maxAmountTitle.textColor = .Pino.label
        maxAmountLabel.textColor = .Pino.label

        backgroundColor = .Pino.background
        contentCardView.backgroundColor = .Pino.secondaryBackground

        contentCardView.layer.cornerRadius = 12

        contentStackView.axis = .vertical

        tokenStackView.alignment = .center

        tokenStackView.spacing = 6
        contentStackView.spacing = 22

        amountTextfield.keyboardType = .decimalPad
        amountTextfield.delegate = self

        amountLabel.numberOfLines = 0
        amountLabel.lineBreakMode = .byCharWrapping
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
        GlobalVariables.shared.$ethGasFee.sink { fee, feeInDollar in
            if self.investVM.selectedToken.isEth {
                self.investVM.updateEthMaxAmount(gasFee: fee, gasFeeInDollar: feeInDollar)
                self.investVM.calculateDollarAmount(self.amountTextfield.text ?? .emptyString)
                self.updateAmount(enteredAmount: self.amountTextfield.text ?? .emptyString)
                self.maxAmountLabel.text = self.investVM.formattedMaxHoldAmount
            }
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
        let amountStatus = investVM.checkBalanceStatus(amount: enteredAmount)
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
        amountLabel.text = investVM.dollarAmount
        if amountTextfield.text == .emptyString {
            continueButton.style = .deactive
        }
    }

    @objc
    private func putMaxAmountInTextField() {
        amountTextfield.text = investVM.maxHoldAmount.sevenDigitFormat
        amountLabel.text = investVM.dollarAmount

        if investVM.selectedToken.isEth {
            investVM.calculateDollarAmount(amountTextfield.text ?? .emptyString)
            maxAmountLabel.text = investVM.formattedMaxHoldAmount
        } else {
            investVM.maxHoldAmount = investVM.selectedToken.holdAmount
            investVM.tokenAmount = investVM.selectedToken.holdAmount.sevenDigitFormat
            investVM.dollarAmount = investVM.selectedToken.holdAmountInDollor.priceFormat
        }

        maxAmountLabel.text = investVM.formattedMaxHoldAmount
        updateAmount(enteredAmount: amountTextfield.text!.trimmCurrency)
    }

    @objc
    private func focusOnAmountTextField() {
        amountTextfield.becomeFirstResponder()
    }
}

extension InvestDepositView: UITextFieldDelegate {
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
