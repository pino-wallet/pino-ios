//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import Combine
import Foundation
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
	private var volatilityDetailButton = UIImageView()
	private var sendReceiveStackView = UIStackView()
	private var sendButton = PinoButton(style: .active)
	private var receiveButton = PinoButton(style: .secondary)
	private var showBalanceButton = UIButton()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public static let headerReuseID = "homepgaeHeader"
	public var portfolioPerformanceTapped: (() -> Void)!

	public var homeVM: HomepageViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupBindings()
			setupConstraint()
		}
	}

	public var receiveButtonTappedClosure: (() -> Void)!
	public var sendButtonTappedClosure: (() -> Void)!

	// MARK: - Private Methods

	private func setupView() {
		let gradientLayer = GradientLayer(frame: bounds, style: .headerBackground)
		layer.addSublayer(gradientLayer)
		balanceStackView.addArrangedSubview(balanceLabel)
		balanceStackView.addArrangedSubview(showBalanceButton)
		balanceStackView.addArrangedSubview(volatilityView)
		volatilityStackView.addArrangedSubview(volatilityPercentageLabel)
		volatilityStackView.addArrangedSubview(volatilitySeparatorLine)
		volatilityStackView.addArrangedSubview(volatilityInDollarLabel)
		volatilityStackView.addArrangedSubview(volatilityDetailButton)
		volatilityView.addSubview(volatilityStackView)
		sendReceiveStackView.addArrangedSubview(sendButton)
		sendReceiveStackView.addArrangedSubview(receiveButton)
		contentStackView.addArrangedSubview(balanceStackView)
		contentStackView.addArrangedSubview(sendReceiveStackView)
		addSubview(contentStackView)
	}

	private func setupStyle() {
		sendButton.title = homeVM.sendButtonTitle
		receiveButton.title = homeVM.receiveButtonTitle
		showBalanceButton.setTitle(
			homeVM.walletBalance.showBalanceButtonTitle,
			for: .normal
		)

		sendButton.setImage(UIImage(systemName: homeVM.sendButtonImage), for: .normal)
		receiveButton.setImage(UIImage(systemName: homeVM.receiveButtonImage), for: .normal)
		volatilityDetailButton.image = UIImage(systemName: "arrow.right")

		let showBalanceImageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .small)
		showBalanceButton.setImage(
			UIImage(systemName: homeVM.walletBalance.showBalanceButtonImage, withConfiguration: showBalanceImageConfig),
			for: .normal
		)

		sendButton.tintColor = .Pino.white
		receiveButton.tintColor = .Pino.primary
		showBalanceButton.tintColor = .Pino.gray2

		balanceLabel.textColor = .Pino.label
		showBalanceButton.setTitleColor(.Pino.gray2, for: .normal)

		volatilityPercentageLabel.font = .PinoStyle.semiboldFootnote
		volatilityInDollarLabel.font = .PinoStyle.semiboldFootnote

		contentStackView.axis = .vertical
		balanceStackView.axis = .vertical
		volatilityStackView.axis = .horizontal
		sendReceiveStackView.axis = .horizontal

		contentStackView.spacing = 25
		balanceStackView.spacing = 13
		sendReceiveStackView.spacing = 24
		volatilityStackView.spacing = 6

		contentStackView.alignment = .center
		balanceStackView.alignment = .center
		sendReceiveStackView.distribution = .fillEqually

		volatilityView.layer.cornerRadius = 14

		sendButton.setConfiguraton(font: .PinoStyle.semiboldCallout!, imagePadding: 8)
		sendButton.addTarget(self, action: #selector(openSendAssetVC), for: .touchUpInside)
		receiveButton.setConfiguraton(font: .PinoStyle.semiboldCallout!, imagePadding: 8)
		receiveButton.addTarget(self, action: #selector(openReceiveButtonVC), for: .touchUpInside)
		showBalanceButton.setConfiguraton(font: .PinoStyle.mediumFootnote!, imagePadding: 5)
		showBalanceButton.isUserInteractionEnabled = false

		balanceStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activateSecurityMode)))
		volatilityView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openVolatilityDetailPage)))
	}

	private func setupBindings() {
		homeVM.$walletBalance.sink { [weak self] walletBalance in
			guard let walletBalance = walletBalance else { return }
			guard let self = self else { return }
			self.balanceLabel.text = walletBalance.balance
			self.volatilityPercentageLabel.text = walletBalance.volatilityPercentage
			self.volatilityInDollarLabel.text = walletBalance.volatilityInDollor

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
			self.volatilityView.backgroundColor = volatilityViewBackgroundColor
			self.volatilitySeparatorLine.backgroundColor = volatilityViewTintColor
			self.volatilityPercentageLabel.textColor = volatilityViewTintColor
			self.volatilityInDollarLabel.textColor = volatilityViewTintColor
			self.volatilityDetailButton.tintColor = volatilityViewTintColor

			if walletBalance.securityMode {
				self.balanceLabel.font = .PinoStyle.boldExtraLargeTitle
				self.volatilityView.isHidden = true
				self.showBalanceButton.isHidden = false
			} else {
				self.balanceLabel.font = .PinoStyle.semiboldLargeTitle
				self.volatilityView.isHidden = false
				self.showBalanceButton.isHidden = true
			}
			self.updateConstraints()
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
		sendReceiveStackView.pin(
			.horizontalEdges
		)
		sendButton.pin(
			.fixedHeight(48)
		)
		receiveButton.pin(
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

	@objc
	private func activateSecurityMode() {
		homeVM.securityMode.toggle()
	}

	@objc
	private func openVolatilityDetailPage() {
		portfolioPerformanceTapped()
	}

	@objc
	private func openSendAssetVC() {}

	@objc
	private func openReceiveButtonVC() {
		receiveButtonTappedClosure()
	}
}
