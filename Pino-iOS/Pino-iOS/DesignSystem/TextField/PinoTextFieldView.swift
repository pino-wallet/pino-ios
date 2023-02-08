//
//  PinoTextField.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

public class PinoTextFieldView: UIView {
	private let textFieldStackView = UIStackView()
	private let textFieldCard = UIView()
	private let textField = UITextField()
	private let errorLabel = UILabel()

	public var style: Style {
		didSet {
			updateStyle()
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

	init(style: Style = .normal, placeholder: String = "", errorText: String = "") {
		self.style = style
		self.placeholderText = placeholder
		self.errorText = errorText
		super.init(frame: .zero)
		setupView()
		setupStyle()
		updateStyle()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		textFieldStackView.addArrangedSubview(textFieldCard)
		textFieldStackView.addArrangedSubview(errorLabel)
		textFieldCard.addSubview(textField)
		addSubview(textFieldStackView)
		textField.delegate = self
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
}

extension PinoTextFieldView: UITextFieldDelegate {
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		textFieldCard.layer.borderColor = UIColor.Pino.green3.cgColor
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		textFieldCard.layer.borderColor = UIColor.Pino.gray5.cgColor
	}
}
