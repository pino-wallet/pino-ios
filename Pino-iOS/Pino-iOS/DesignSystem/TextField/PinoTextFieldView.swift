//
//  PinoTextField.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

public class PinoTextFieldView: UIView {
	public var style: Style {
		didSet {
			updateStyle()
		}
	}
    public var customRightView: UIView! {
        didSet {
            updateStyle()
        }
    }
    
    public var errorText: String! {
        didSet {
            updateStyle()
        }
    }
    
    
    let textField = UITextField()
    let errorLabel = UILabel()

	init(style: Style) {
		self.style = style
		super.init(frame: .zero)
		updateStyle()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateStyle() {
        addSubview(textField)
        
        // Setup error label
        addSubview(errorLabel)
        errorLabel.isHidden = true
        errorLabel.textColor = .Pino.red
        errorLabel.font = UIFont.PinoStyle.mediumFootnote
        
        
		textField.attributedPlaceholder = NSAttributedString(
			string: textField.placeholder ?? " ",
			attributes: [NSAttributedString.Key.foregroundColor: style.placeholderColor]
		)
        textField.layer.cornerRadius = 8
		textField.layer.borderWidth = 1
		textField.layer.borderColor = style.borderColor.cgColor
		textField.backgroundColor = .Pino.secondaryBackground
		textField.textColor = style.textColor
		textField.delegate = self
		textField.font = UIFont.PinoStyle.mediumBody
		let textFieldLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 48))
		textField.leftView = textFieldLeftView
		textField.leftViewMode = .always
        let textFieldRightView = UIView()
        textFieldRightView.translatesAutoresizingMaskIntoConstraints = false
        textFieldRightView.pin(.fixedWidth(46), .fixedHeight(48))
        let errorIcon = UIImageView(image: UIImage(named: "error"))
       textField.rightView = textFieldRightView
        textField.rightViewMode = .always
                        switch style {
            case .error:
                            pin(.fixedHeight(74))
                textFieldRightView.addSubview(errorIcon)
                            errorIcon.pin(
                                .centerY(to: errorIcon.superview),
                                .centerX(to: errorIcon.superview)
                            )
                            errorLabel.isHidden = false
                            errorLabel.text = errorText
                        case .customRightView:
                            pin(.fixedHeight(48))
                            guard let customRightView = customRightView as UIView? else {
                                return
                            }
                textFieldRightView.addSubview(customRightView)
                            customRightView.pin(
                                .centerY(to: customRightView.superview),
                                .centerX(to: customRightView.superview)
                            )
                        default:
                            pin(.fixedHeight(48))
                            textField.rightViewMode = .never
            }
	}

	private func setupConstraints() {
        textField.pin(.fixedHeight(48), .top(to: superview, padding: 0), .horizontalEdges(to: superview, padding: 0))
        errorLabel.pin(.relative(.top, 8, to: textField, .bottom))
	}
}

extension PinoTextFieldView: UITextFieldDelegate {
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.layer.borderColor = style.editingBorderColor.cgColor
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		textField.layer.borderColor = style.borderColor.cgColor
	}
}
