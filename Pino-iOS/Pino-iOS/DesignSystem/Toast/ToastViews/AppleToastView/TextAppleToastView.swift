//
//  TextToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import Foundation
import UIKit

public class TextToastView: UIStackView {
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		return label
	}()

	private lazy var subtitleLabel: UILabel = {
		UILabel()
	}()

	public init(_ title: NSAttributedString, subtitle: NSAttributedString? = nil) {
		super.init(frame: CGRect.zero)
		commonInit()

		titleLabel.attributedText = title
		addArrangedSubview(titleLabel)

		if let subtitle = subtitle {
			subtitleLabel.attributedText = subtitle
			addArrangedSubview(subtitleLabel)
		}
	}

	public init(_ title: String, subtitle: String? = nil) {
		super.init(frame: CGRect.zero)
		commonInit()

		titleLabel.text = title
		titleLabel.font = .PinoStyle.boldFootnote
		addArrangedSubview(titleLabel)

		if let subtitle = subtitle {
			subtitleLabel.textColor = .systemGray
			subtitleLabel.text = subtitle
			subtitleLabel.font = .PinoStyle.semiboldFootnote
			addArrangedSubview(subtitleLabel)
		}
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func commonInit() {
		axis = .vertical
		alignment = .center
		distribution = .fillEqually
	}
}
