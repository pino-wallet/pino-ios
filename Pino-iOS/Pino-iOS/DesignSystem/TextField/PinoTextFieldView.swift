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

	// MARK: - Private Properties

	private let textFieldStackView = UIStackView()
	private let textFieldCard = UIView()
	private let textField = UITextField()
	private let errorLabel = UILabel()
	private let pendingLoading = PinoLoading(size: 22)

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

	public var errorText: String {
		didSet {
			updateErrorText(errorText)
		}
	}

	public var text: String? {
		didSet {
			textField.text = text
		}
	}

	

	// MARK: - Initializers

	init(
		style: Style = .normal,
		placeholder: String = "",
		errorText: String = "",
		returnKeyType: UIReturnKeyType = .default
	) {
		self.style = style
		self.placeholderText = placeholder
		self.errorText = errorText
		self.returnKeyType = returnKeyType
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
		textField.text == nil || textField.text == ""
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
	}

	private func updateStyle() {
		switch style {
		case .normal:
			textField.rightViewMode = .never
			errorLabel.isHidden = true
		case .error:
			textField.rightView = UIImageView(image: UIImage(named: "error"))
			textField.rightViewMode = .always
			errorLabel.isHidden = false
		case .success:
			textField.rightView = UIImageView(image: UIImage(named: "done"))
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		case let .customIcon(customView):
			textField.rightView = customView
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		case .pending:
			textField.rightView = pendingLoading
			textField.rightViewMode = .always
			errorLabel.isHidden = true
		}
	}

	private func updateErrorText(_ errorText: String) {
		errorLabel.text = errorText
	}

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
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		textFieldCard.layer.borderColor = UIColor.Pino.gray5.cgColor
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let textFieldKeyboardOnReturn = textFieldKeyboardOnReturn {
			textFieldKeyboardOnReturn()
		}
		return true
	}
}
