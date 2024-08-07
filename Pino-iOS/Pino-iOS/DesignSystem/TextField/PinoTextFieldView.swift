//
//  PinoTextField.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

public class PinoTextFieldView: UIView {
	// MARK: - Public Methods

	public var textFieldKeyboardOnReturn: (() -> Void)?
	public var textDidChange: (() -> Void)?
	public var editingBegin: (() -> Void)?
	public var editingEnd: (() -> Void)?
	public var validationPattern: () -> Bool = { true }

	// MARK: - Private Properties

	private let textFieldStackView = UIStackView()
	private let textFieldCard = UIView()
	private let textField = UITextField()
	private let errorLabel = UILabel()
	private let pendingLoading = PinoLoading(size: 24)
	private var pattern: Pattern?

	// MARK: - Public Properties

	public var style: Style {
		didSet {
			updateStyle()
		}
	}

	public var returnKeyType: UIReturnKeyType {
		didSet {
			updateReturnKeyType(newType: returnKeyType)
		}
	}

	public var placeholderText: String {
		didSet {
			updatePlaceholder(placeholderText)
		}
	}

//	public var errorText: String {
//		didSet {
//			updateErrorText(errorText)
//		}
//	}

	public var text: String? {
		set {
			textField.text = newValue
			textField.font = .PinoStyle.mediumBody
		}
		get {
			textField.text
		}
	}

	public var attributedText: NSMutableAttributedString? {
		didSet {
			textField.attributedText = attributedText
		}
	}

	// MARK: - Initializers

	init(
		style: Style = .normal,
		placeholder: String = "",
//		errorText: String = "",
		pattern: Pattern?,
		returnKeyType: UIReturnKeyType = .default
	) {
		self.style = style
		self.placeholderText = placeholder
//		self.errorText = errorText
		self.returnKeyType = returnKeyType
		self.pattern = pattern
		super.init(frame: .zero)
		setupView()
		setupStyle()
		updateStyle()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func isEmpty() -> Bool {
		textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false
	}

	public func getText() -> String? {
		if isEmpty() {
			return nil
		} else {
			return textField.text
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		textFieldStackView.addArrangedSubview(textFieldCard)
		textFieldStackView.addArrangedSubview(errorLabel)
		textFieldCard.addSubview(textField)
		addSubview(textFieldStackView)
		textField.delegate = self
		textField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
	}

	private func setupStyle() {
		errorLabel.textColor = .Pino.red
		errorLabel.font = UIFont.PinoStyle.mediumFootnote
		textFieldCard.backgroundColor = .Pino.secondaryBackground
		textFieldCard.layer.borderColor = UIColor.Pino.gray5.cgColor
		textFieldCard.layer.cornerRadius = 8
		textFieldCard.layer.borderWidth = 1
		textField.textColor = .Pino.label
		textField.font = .PinoStyle.mediumBody
		textFieldStackView.axis = .vertical
		textFieldStackView.spacing = 8
		textField.keyboardType = .asciiCapable
	}

	private func updateStyle() {
		switch style {
		case .normal:
			textField.rightViewMode = .never
			errorLabel.isHidden = true
		case .error:
			textField.setRightViewWithPadding(UIImageView(image: UIImage(named: "error")), paddingLeft: 10)
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		case .success:
			textField.setRightViewWithPadding(UIImageView(image: UIImage(named: "done")), paddingLeft: 10)
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		case let .customView(customView):
			textField.setRightViewWithPadding(customView, paddingLeft: 10)
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		case .pending:
			textField.setRightViewWithPadding(pendingLoading, paddingLeft: 10)
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		}
	}

//	private func updateErrorText(_ errorText: String) {
//		errorLabel.text = errorText
//	}

	private func updatePlaceholder(_ placeholder: String) {
		textField.attributedPlaceholder = NSAttributedString(
			string: placeholder,
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.Pino.gray2]
		)
	}

	private func setupConstraints() {
		textFieldStackView.pin(.allEdges)
		textField.pin(.fixedHeight(48), .verticalEdges(), .horizontalEdges(padding: 14))
	}

	private func updateReturnKeyType(newType: UIReturnKeyType) {
		textField.returnKeyType = newType
	}

	@objc
	private func textFieldTextDidChange() {
		if let textDidChange {
			textDidChange()
		}
	}
}

extension PinoTextFieldView: UITextFieldDelegate {
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		textFieldCard.layer.borderColor = UIColor.Pino.green3.cgColor
		if let editingBegin {
			editingBegin()
		}
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		textFieldCard.layer.borderColor = UIColor.Pino.gray5.cgColor
		if let editingEnd {
			editingEnd()
		}
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let textFieldKeyboardOnReturn = textFieldKeyboardOnReturn {
			textFieldKeyboardOnReturn()
		}
		return true
	}

	public func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		guard let pattern else {
			return true
		}
		switch pattern {
		case .number:
			return textField.isNumber(charactersRange: range, replacementString: string)
		case .alphaNumeric:
			return textField.isAlphaNumeric(charactersRange: range, replacementString: string)
		}
	}
}

extension UITextField {
	fileprivate func setRightViewWithPadding(_ view: UIView, paddingLeft: CGFloat) {
		let rightViewContentSize = CGFloat(24)
		view.translatesAutoresizingMaskIntoConstraints = true

		let outerView = UIView()
		outerView.translatesAutoresizingMaskIntoConstraints = true
		outerView.addSubview(view)

		outerView.frame = CGRect(
			origin: .zero,
			size: CGSize(
				width: rightViewContentSize,
				height: rightViewContentSize
			)
		)

		view.center = CGPoint(
			x: outerView.bounds.size.width - (rightViewContentSize / 2),
			y: outerView.bounds.size.height / 2
		)
		view.pin(.verticalEdges(padding: 0), .trailing(padding: 0), .leading(padding: 10))

		rightView = outerView
	}
}
