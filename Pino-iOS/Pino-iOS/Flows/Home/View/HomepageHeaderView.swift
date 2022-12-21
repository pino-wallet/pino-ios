//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import Combine
import UIKit

class HomepageHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private var contentStackView = UIStackView()
	private var balanceStackView = UIStackView()
	private var balanceLabel = UILabel()
	private var volatilityStackView = UIStackView()
	private var volatilityView = UIView()
	private var volatilityPercentageLabel = UILabel()
	private var volatilityInDollarLabel = UILabel()
	private var volatilitySeparatorLine = UIView()
	private var sendRecieveStackView = UIStackView()
	private var sendButton = PinoButton(style: .active)
	private var recieveButton = PinoButton(style: .secondary)
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public static let headerReuseID = "homepgaeHeader"

	public var homeVM: HomepageViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupBindings()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		setupGradientLayer()

		balanceStackView.addArrangedSubview(balanceLabel)
		balanceStackView.addArrangedSubview(volatilityView)
		volatilityStackView.addArrangedSubview(volatilityPercentageLabel)
		volatilityStackView.addArrangedSubview(volatilitySeparatorLine)
		volatilityStackView.addArrangedSubview(volatilityInDollarLabel)
		volatilityView.addSubview(volatilityStackView)
		sendRecieveStackView.addArrangedSubview(sendButton)
		sendRecieveStackView.addArrangedSubview(recieveButton)
		contentStackView.addArrangedSubview(balanceStackView)
		contentStackView.addArrangedSubview(sendRecieveStackView)
		addSubview(contentStackView)
	}

	private func setupStyle() {
		sendButton.title = homeVM.sendButtonTitle
		recieveButton.title = homeVM.recieveButtonTitle

		sendButton.setImage(UIImage(systemName: homeVM.sendButtonImage), for: .normal)
		recieveButton.setImage(UIImage(systemName: homeVM.recieveButtonImage), for: .normal)

		sendButton.tintColor = .Pino.white
		recieveButton.tintColor = .Pino.primary

		balanceLabel.textColor = .Pino.label

		balanceLabel.font = .PinoStyle.semiboldLargeTitle
		volatilityPercentageLabel.font = .PinoStyle.semiboldFootnote
		volatilityInDollarLabel.font = .PinoStyle.semiboldFootnote

		contentStackView.axis = .vertical
		balanceStackView.axis = .vertical
		volatilityStackView.axis = .horizontal
		sendRecieveStackView.axis = .horizontal

		contentStackView.spacing = 25
		balanceStackView.spacing = 13
		sendRecieveStackView.spacing = 24
		volatilityStackView.spacing = 6

		contentStackView.alignment = .center
		balanceStackView.alignment = .center
		sendRecieveStackView.distribution = .fillEqually

		volatilityView.layer.cornerRadius = 14

		sendButton.configuration = .plain()
		recieveButton.configuration = .plain()
		sendButton.configuration?.imagePadding = 8
		recieveButton.configuration?.imagePadding = 8

		sendButton.configuration?.titleTextAttributesTransformer =
			UIConfigurationTextAttributesTransformer { btnConfig in
				var sendButtonConfig = btnConfig
				sendButtonConfig.font = UIFont.PinoStyle.semiboldCallout
				return sendButtonConfig
			}

		recieveButton.configuration?.titleTextAttributesTransformer =
			UIConfigurationTextAttributesTransformer { btnConfig in
				var recieveButtonConfig = btnConfig
				recieveButtonConfig.font = UIFont.PinoStyle.semiboldCallout
				return recieveButtonConfig
			}
	}

	private func setupBindings() {
		homeVM.$walletBalance.sink { [weak self] walletBalance in
			guard let walletBalance = walletBalance else { return }

			self?.balanceLabel.text = walletBalance.balance
			self?.volatilityPercentageLabel.text = walletBalance.volatilityPercentage
			self?.volatilityInDollarLabel.text = walletBalance.volatilityInDollor

			var volatilityViewBackgroundColor: UIColor!
			var volatilityViewTintColor: UIColor!
			switch walletBalance.volatilityType {
			case .profit:
				volatilityViewBackgroundColor = .Pino.green1
				volatilityViewTintColor = .Pino.green3
			case .loss:
				volatilityViewBackgroundColor = .Pino.lightRed
				volatilityViewTintColor = .Pino.red
			}

			self?.volatilityView.backgroundColor = volatilityViewBackgroundColor
			self?.volatilitySeparatorLine.backgroundColor = volatilityViewTintColor
			self?.volatilityPercentageLabel.textColor = volatilityViewTintColor
			self?.volatilityInDollarLabel.textColor = volatilityViewTintColor
			self?.updateConstraints()
		}
		.store(in: &cancellables)
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 12)
		)
		volatilityStackView.pin(
			.centerY,
			.horizontalEdges(padding: 12)
		)
		volatilityView.pin(
			.fixedHeight(28)
		)
		sendRecieveStackView.pin(
			.horizontalEdges
		)
		sendButton.pin(
			.fixedHeight(48)
		)
		recieveButton.pin(
			.fixedHeight(48)
		)

		volatilitySeparatorLine.pin(
			.fixedWidth(0.6),
			.verticalEdges
		)
	}

	private func setupGradientLayer() {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.locations = [0.2, 0.5]
		gradientLayer.colors = [
			UIColor.Pino.secondaryBackground.cgColor,
			UIColor.Pino.background.cgColor,
		]
		layer.addSublayer(gradientLayer)
	}
}
