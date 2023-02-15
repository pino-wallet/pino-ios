//
//  PasteFromClipboardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class PasteFromClipboardView: UIView {
	// MARK: - Public Properties

	public var contractAddress: String {
		didSet {
			setupContractAddressLabel()
		}
	}

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let pasteButton = UIButton()
	private var contractAddressLabel: PinoLabel?
	private let pasteButtonIcon = UIImage(named: "copy")

	// MARK: - Initializers

	init(contractAddress: String) {
		self.contractAddress = contractAddress
		super.init(frame: .zero)

		setupView()
		setupConstraints()
		setupContractAddressLabel()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

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

		// Setup stackview
		addSubview(mainStackView)
		mainStackView.axis = .vertical
		mainStackView.alignment = .leading
		mainStackView.addArrangedSubview(pasteButton)
		mainStackView.spacing = 6
	}

	private func setupConstraints() {
		mainStackView.pin(.verticalEdges(to: superview, padding: 12), .horizontalEdges(to: superview, padding: 14))
	}

	private func setupContractAddressLabel() {
		// Setup contract address label view
		contractAddressLabel = PinoLabel(
			style: PinoLabel
				.Style(textColor: .Pino.label, font: UIFont.PinoStyle.mediumSubheadline, numberOfLine: 0, lineSpacing: 6),
			text: contractAddress
		)
		contractAddressLabel?.lineBreakMode = .byWordWrapping
		mainStackView.addArrangedSubview(contractAddressLabel ?? UIView())
	}
}
