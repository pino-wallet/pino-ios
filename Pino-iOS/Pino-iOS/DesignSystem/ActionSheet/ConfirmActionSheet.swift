//
//  SelectActionSheet.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/26/23.
//

import UIKit

class ConfirmActionSheet: UIViewController {
	// MARK: - Private Properties

	private let dismissButton = UIButton()
	private let mainStackView = UIStackView()
	private let messageAndActionsStackView = UIStackView()
	private let customCornerRadius = CGFloat(12)
	private let descriptionLabelContainerView = UIView()

	// MARK: Public Properties

	public let descriptionLabel = PinoLabel(style: .description, text: "")
	public var dismissButtonTitle = "Cancel" {
		didSet {
			dismissButton.setTitle(dismissButtonTitle, for: .normal)
		}
	}

	public var descriptionText: String? {
		didSet {
			descriptionLabel.text = descriptionText
			descriptionLabel.textAlignment = .center
			descriptionLabel.isHidden = false
		}
	}

	// MARK: - Public Methods

	public func addConfirmActionSheetButton(confirmActionSheetButton: ConfirmActionSheetButton) {
		confirmActionSheetButton.dismissActionsheetClosure = { [weak self] in
			self?.dismiss(animated: true)
		}
		messageAndActionsStackView.addArrangedSubview(confirmActionSheetButton)
	}

	// MARK: - Initializers

	init() {
		super.init(nibName: nil, bundle: nil)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		modalPresentationStyle = .overCurrentContext
		modalTransitionStyle = .crossDissolve

		view.backgroundColor = .Pino.black.withAlphaComponent(0.4)

		mainStackView.axis = .vertical
		mainStackView.spacing = 8
		mainStackView.alignment = .fill

		dismissButton.backgroundColor = .Pino.secondaryBackground
		dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
		dismissButton.layer.cornerRadius = customCornerRadius
		dismissButton.setTitle(dismissButtonTitle, for: .normal)
		dismissButton.setTitleColor(UIColor.Pino.blue, for: .normal)
		dismissButton.setConfiguraton(font: UIFont.PinoStyle.semiboldTitle3!, titlePadding: 16)

		messageAndActionsStackView.axis = .vertical
		messageAndActionsStackView.alignment = .fill
		messageAndActionsStackView.backgroundColor = .Pino.gray7
		messageAndActionsStackView.layer.cornerRadius = customCornerRadius

		descriptionLabelContainerView.addSubview(descriptionLabel)

		messageAndActionsStackView.addArrangedSubview(descriptionLabelContainerView)

		descriptionLabel.isHidden = true
		descriptionLabel.lineBreakMode = .byWordWrapping
		descriptionLabel.font = UIFont.PinoStyle.mediumSubheadline
		descriptionLabel.textColor = .Pino.label

		mainStackView.addArrangedSubview(messageAndActionsStackView)
		mainStackView.addArrangedSubview(dismissButton)
		view.addSubview(mainStackView)
	}

	private func setupConstraints() {
		dismissButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 61).isActive = true
		descriptionLabel.pin(.verticalEdges(padding: 12), .horizontalEdges(padding: 16))
		mainStackView.pin(.horizontalEdges(padding: 16), .bottom(padding: 32))
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}
