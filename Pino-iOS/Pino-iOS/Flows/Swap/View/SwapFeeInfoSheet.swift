//
//  SwapFeeInfoSheet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/6/23.
//

import UIKit

class SwapFeeInfoSheet: UIAlertController {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let titleIcon = UIImageView()

	private let feeStackView = UIStackView()
	private let networkFeeStackView = UIStackView()
	private let pinoFeeStackView = UIStackView()

	private let networkFeeLabelTitle = PinoLabel(style: .description, text: "Network")
	private let pinoFeeLabelTitle = PinoLabel(style: .description, text: "Pino")
	private let networkFeeLabel = PinoLabel(style: .info, text: nil)
	private let pinoFeeLabel = PinoLabel(style: .info, text: nil)

	private let actionButton = PinoButton(style: .active)

	// MARK: - Public Properties

	public var actionButtonTitle = "Got it"
	public var onActionButtonTap: (() -> Void)?

	// MARK: - Initializers

	convenience init(title: String, networkFee: String, pinoFee: String) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		setupView()
		setupStyle(title: title, networkFee: networkFee, pinoFee: pinoFee)
		setupConstraint()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(feeStackView)
		contentStackView.addArrangedSubview(pinoFeeStackView)
		contentStackView.addArrangedSubview(networkFeeStackView)
		contentStackView.addArrangedSubview(actionButton)
		titleStackView.addArrangedSubview(titleIcon)
		titleStackView.addArrangedSubview(titleLabel)
		pinoFeeStackView.addArrangedSubview(pinoFeeLabelTitle)
		pinoFeeStackView.addArrangedSubview(pinoFeeLabel)

		networkFeeStackView.addArrangedSubview(networkFeeLabelTitle)
		networkFeeStackView.addArrangedSubview(networkFeeLabel)

		feeStackView.addArrangedSubview(pinoFeeStackView)
		feeStackView.addArrangedSubview(networkFeeStackView)

		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle(title: String, networkFee: String, pinoFee: String) {
		titleLabel.text = title
		pinoFeeLabel.text = networkFee
		networkFeeLabel.text = pinoFee
		titleLabel.text = title
		actionButton.title = actionButtonTitle

		titleIcon.image = UIImage(named: "info")
		titleIcon.tintColor = .Pino.primary

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .horizontal
		feeStackView.axis = .vertical
		pinoFeeStackView.axis = .horizontal
		networkFeeStackView.axis = .horizontal

		pinoFeeStackView.distribution = .equalCentering
		networkFeeStackView.distribution = .equalCentering

		contentStackView.spacing = 24
		titleStackView.spacing = 6
		feeStackView.spacing = 24

		actionButton.addAction(UIAction(handler: { _ in
			if let onButtonTap = self.onActionButtonTap {
				onButtonTap()
			} else {
				self.dismiss(animated: true)
			}
		}), for: .touchUpInside)
	}

	private func setupConstraint() {
		titleIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		actionButton.pin(
			.fixedWidth(300)
		)
		contentStackView.pin(
			.allEdges(padding: 16)
		)
		contentView.pin(
			.allEdges
		)
	}
}
