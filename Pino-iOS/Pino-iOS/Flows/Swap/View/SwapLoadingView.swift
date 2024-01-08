//
//  swapLoadingView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/17/23.
//

import Foundation
import UIKit

class SwapLoadingView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let protocolCardView = PinoContainerCard()
	private let swapCardView = PinoContainerCard()
	private let protocolStackView = UIStackView()
	private let protocolImage = UIImageView()
	private let protocolName = UILabel()
	private let swapStackView = UIStackView()
	private let switchTokenView = UIView()
	private let switchTokenLineView = UIView()
	private let switchTokenButton = UIButton()

	private let fromTokenStackView = UIStackView()
	private let fromTokenTextFieldStackView = UIStackView()
	private let fromTokenAmountTextfield = UITextField()
	private let fromTokenMaxAmountLabel = UILabel()
	private let fromTokenView = UIView()
	private let fromTokenSpacerView = UIView()

	private let toTokenStackView = UIStackView()
	private let toTokenTextFieldStackView = UIStackView()
	private let toTokenAmountTextfield = UITextField()
	private let toTokenView = UIView()
	private let toTokenSpacerView = UIView()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(protocolCardView)
		contentStackView.addArrangedSubview(swapCardView)
		protocolCardView.addSubview(protocolStackView)
		protocolStackView.addArrangedSubview(protocolImage)
		protocolStackView.addArrangedSubview(protocolName)
		swapCardView.addSubview(swapStackView)
		swapStackView.addArrangedSubview(fromTokenStackView)
		swapStackView.addArrangedSubview(switchTokenView)
		swapStackView.addArrangedSubview(toTokenStackView)
		switchTokenView.addSubview(switchTokenLineView)
		switchTokenView.addSubview(switchTokenButton)

		fromTokenStackView.addArrangedSubview(fromTokenTextFieldStackView)
		fromTokenStackView.addArrangedSubview(fromTokenMaxAmountLabel)
		fromTokenTextFieldStackView.addArrangedSubview(fromTokenAmountTextfield)
		fromTokenTextFieldStackView.addArrangedSubview(fromTokenSpacerView)
		fromTokenTextFieldStackView.addArrangedSubview(fromTokenView)

		toTokenStackView.addArrangedSubview(toTokenAmountTextfield)
		toTokenStackView.addArrangedSubview(toTokenSpacerView)
		toTokenStackView.addArrangedSubview(toTokenView)
	}

	private func setupStyle() {
		switchTokenButton.setImage(UIImage(named: "arrow_down"), for: .normal)
		switchTokenButton.tintColor = .Pino.primary

		protocolName.font = .PinoStyle.mediumBody

		protocolName.textColor = .Pino.label
		switchTokenButton.setTitleColor(.Pino.primary, for: .normal)

		backgroundColor = .Pino.background
		switchTokenLineView.backgroundColor = .Pino.background
		switchTokenButton.backgroundColor = .Pino.background

		contentStackView.axis = .vertical
		swapStackView.axis = .vertical
		fromTokenStackView.axis = .vertical

		contentStackView.spacing = 12
		protocolStackView.spacing = 8
		swapStackView.spacing = 10
		fromTokenStackView.spacing = 16

		protocolStackView.alignment = .center
		fromTokenTextFieldStackView.alignment = .center
		fromTokenStackView.alignment = .trailing
		toTokenStackView.alignment = .center

		switchTokenButton.layer.cornerRadius = 12
		protocolImage.layer.cornerRadius = 20
		protocolName.layer.cornerRadius = 12
		fromTokenView.layer.cornerRadius = 20
		toTokenView.layer.cornerRadius = 20
		fromTokenAmountTextfield.layer.cornerRadius = 16
		toTokenAmountTextfield.layer.cornerRadius = 16
		fromTokenMaxAmountLabel.layer.cornerRadius = 12

		protocolImage.layer.masksToBounds = true
		protocolName.layer.masksToBounds = true
		fromTokenView.layer.masksToBounds = true
		toTokenView.layer.masksToBounds = true
		fromTokenAmountTextfield.layer.masksToBounds = true
		toTokenAmountTextfield.layer.masksToBounds = true
		fromTokenMaxAmountLabel.layer.masksToBounds = true

		protocolImage.isSkeletonable = true
		protocolName.isSkeletonable = true
		fromTokenView.isSkeletonable = true
		toTokenView.isSkeletonable = true
		fromTokenAmountTextfield.isSkeletonable = true
		toTokenAmountTextfield.isSkeletonable = true
		fromTokenMaxAmountLabel.isSkeletonable = true
		showSkeletonView()
	}

	private func setupContstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 18)
		)
		protocolStackView.pin(
			.leading(padding: 14),
			.verticalEdges(padding: 8)
		)
		protocolImage.pin(
			.fixedHeight(40),
			.fixedWidth(40)
		)
		protocolName.pin(
			.fixedWidth(70),
			.fixedHeight(24)
		)
		swapStackView.pin(
			.top(padding: 24),
			.bottom(padding: 64),
			.horizontalEdges(padding: 14)
		)
		switchTokenLineView.pin(
			.horizontalEdges,
			.centerY,
			.fixedHeight(1)
		)
		switchTokenButton.pin(
			.fixedWidth(40),
			.fixedHeight(40),
			.verticalEdges,
			.centerX
		)
		fromTokenView.pin(
			.fixedWidth(100),
			.fixedHeight(40)
		)
		toTokenView.pin(
			.fixedWidth(100),
			.fixedHeight(40)
		)

		fromTokenAmountTextfield.pin(
			.fixedWidth(70),
			.fixedHeight(32)
		)
		toTokenAmountTextfield.pin(
			.fixedWidth(70),
			.fixedHeight(32)
		)
		fromTokenMaxAmountLabel.pin(
			.fixedWidth(80),
			.fixedHeight(24)
		)
		fromTokenTextFieldStackView.pin(
			.horizontalEdges
		)
	}
}
