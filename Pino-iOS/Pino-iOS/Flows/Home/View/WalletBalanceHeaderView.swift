//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import Combine
import UIKit

class WalletBalanceHeaderView: UICollectionReusableView {
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
	private var showBalanceButton = UIButton()
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
		balanceStackView.addArrangedSubview(showBalanceButton)
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
		showBalanceButton.setTitle(
			homeVM.walletBalance.showBalanceButtonTitle,
			for: .normal
		)

		sendButton.setImage(UIImage(systemName: homeVM.sendButtonImage), for: .normal)
		recieveButton.setImage(UIImage(systemName: homeVM.recieveButtonImage), for: .normal)

		let showBalanceImageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .small)
		showBalanceButton.setImage(
			UIImage(systemName: homeVM.walletBalance.showBalanceButtonImage, withConfiguration: showBalanceImageConfig),
			for: .normal
		)

		sendButton.tintColor = .Pino.white
		recieveButton.tintColor = .Pino.primary
		showBalanceButton.tintColor = .Pino.gray2

		balanceLabel.textColor = .Pino.label
		showBalanceButton.setTitleColor(.Pino.gray2, for: .normal)

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
		showBalanceButton.configuration = .plain()

		sendButton.configuration?.imagePadding = 8
		recieveButton.configuration?.imagePadding = 8
		showBalanceButton.configuration?.imagePadding = 5

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

		showBalanceButton.configuration?.titleTextAttributesTransformer =
			UIConfigurationTextAttributesTransformer { btnConfig in
				var showBalanceButtonConfig = btnConfig
				showBalanceButtonConfig.font = UIFont.PinoStyle.mediumFootnote
				return showBalanceButtonConfig
			}

		balanceStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activateSecurityMode)))

		showBalanceButton.addAction(UIAction(handler: { _ in
			self.deactivateSecurityMode()
		}), for: .touchUpInside)
	}

	private func setupBindings() {
		homeVM.$walletBalance.sink { [weak self] walletBalance in
			guard let walletBalance = walletBalance else { return }

			if walletBalance.securityMode {
				let attributedString = NSMutableAttributedString(string: walletBalance.securityModeText)
				let paragraphStyle = NSMutableParagraphStyle()
				paragraphStyle.lineSpacing = 0
				attributedString.addAttribute(
					.paragraphStyle,
					value: paragraphStyle,
					range: NSRange(location: 0, length: attributedString.length)
				)
				attributedString.addAttribute(
					.kern,
					value: -8,
					range: NSRange(location: 0, length: attributedString.length)
				)
				attributedString.addAttribute(
					.font,
					value: UIFont.systemFont(ofSize: 80),
					range: NSRange(location: 0, length: attributedString.length)
				)
				self?.balanceLabel.attributedText = attributedString

				self?.volatilityView.isHidden = true
				self?.showBalanceButton.isHidden = false

			} else {
				self?.balanceLabel.attributedText = nil
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
				case .none:
					volatilityViewBackgroundColor = .Pino.gray5
					volatilityViewTintColor = .Pino.gray2
				}

				self?.volatilityView.backgroundColor = volatilityViewBackgroundColor
				self?.volatilitySeparatorLine.backgroundColor = volatilityViewTintColor
				self?.volatilityPercentageLabel.textColor = volatilityViewTintColor
				self?.volatilityInDollarLabel.textColor = volatilityViewTintColor

				self?.volatilityView.isHidden = false
				self?.showBalanceButton.isHidden = true
			}
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
		showBalanceButton.pin(
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
		balanceLabel.pin(
			.fixedHeight(41)
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

	@objc
	private func activateSecurityMode() {
		homeVM.securityMode = true
	}

	private func deactivateSecurityMode() {
		homeVM.securityMode = false
	}
}
