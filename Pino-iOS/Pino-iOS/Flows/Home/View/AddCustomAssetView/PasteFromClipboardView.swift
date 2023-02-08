//
//  PasteFromClipboardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class PasteFromClipboardView: UIView {
	// MARK: - Public Properties

	public var contractAddress: String

	// MARK: - Private Properties

	private let stackView = UIStackView()
	private let pasteButton = UIButton()
	private let contractAddressLabel = PinoLabel(
		style: PinoLabel
			.Style(textColor: .Pino.label, font: UIFont.PinoStyle.mediumSubheadline, numberOfLine: 0, lineSpacing: 6),
		text: ""
	)
	private let pasteButtonIcon = UIImage(named: "copy")

	init(contractAddress: String) {
		self.contractAddress = contractAddress
		super.init(frame: .zero)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		// Setup self view
		backgroundColor = .Pino.secondaryBackground
		layer.borderWidth = 1
		layer.borderColor = UIColor.Pino.gray5.cgColor
		layer.cornerRadius = 8

		// Setup paste button view
		pasteButton.setImage(UIImage(named: "copy"), for: .normal)
		pasteButton.setTitle("Paste from clipboard", for: .normal)
		pasteButton.setTitleColor(.Pino.green3, for: .normal)
		pasteButton.tintColor = .Pino.primary
		pasteButton.setConfiguraton(font: .PinoStyle.semiboldSubheadline!, imagePadding: 4)
		var pasteButtonContentInsets = NSDirectionalEdgeInsets()
		pasteButtonContentInsets.leading = 0
		pasteButton.configuration?.contentInsets = pasteButtonContentInsets

		// Setup contract address label view
		contractAddressLabel.text = contractAddress
		contractAddressLabel.font = UIFont.PinoStyle.mediumSubheadline
		contractAddressLabel.lineBreakMode = .byWordWrapping

		// Setup stackview
		addSubview(stackView)
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.addArrangedSubview(pasteButton)
		stackView.addArrangedSubview(contractAddressLabel)
		stackView.spacing = 6
	}

	private func setupConstraints() {
		stackView.pin(.verticalEdges(to: superview, padding: 12), .horizontalEdges(to: superview, padding: 14))
	}
}
