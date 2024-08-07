//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import Combine
import Foundation
import UIKit

class AccountBalanceHeaderView: UICollectionReusableView {
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
		setSkeletonable()

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
			homeVM.showBalanceButtonTitle,
			for: .normal
		)

		sendButton.setImage(UIImage(named: homeVM.sendButtonImage)?.withRenderingMode(.automatic), for: .normal)
		receiveButton.setImage(UIImage(named: homeVM.receiveButtonImage)?.withRenderingMode(.automatic), for: .normal)

		let showBalanceImageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .small)
		showBalanceButton.setImage(
			UIImage(systemName: homeVM.showBalanceButtonImage, withConfiguration: showBalanceImageConfig),
			for: .normal
		)

		sendButton.tintColor = .Pino.white
		receiveButton.tintColor = .Pino.primary
		receiveButton.backgroundColor = .Pino.white
		showBalanceButton.tintColor = .Pino.gray2

		balanceLabel.textColor = .Pino.label
		balanceLabel.textAlignment = .center
		showBalanceButton.setTitleColor(.Pino.gray2, for: .normal)

		volatilityPercentageLabel.font = .PinoStyle.semiboldFootnote
		volatilityInDollarLabel.font = .PinoStyle.semiboldFootnote

		contentStackView.axis = .vertical
		balanceStackView.axis = .vertical
		volatilityStackView.axis = .horizontal
		sendReceiveStackView.axis = .horizontal

		contentStackView.spacing = 32
		balanceStackView.spacing = 10
		sendReceiveStackView.spacing = 24
		volatilityStackView.spacing = 5

		contentStackView.alignment = .center
		balanceStackView.alignment = .center
		sendReceiveStackView.distribution = .fillEqually

		volatilityView.layer.cornerRadius = 14
		volatilityView.layer.masksToBounds = true
		balanceLabel.isUserInteractionEnabled = true

		sendButton.setConfiguraton(
			font: .PinoStyle.semiboldCallout!,
			imagePadding: 10,
			contentInset: NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 13)
		)
		sendButton.addTarget(self, action: #selector(openSendAssetVC), for: .touchUpInside)
		receiveButton.setConfiguraton(
			font: .PinoStyle.semiboldCallout!,
			imagePadding: 10,
			contentInset: NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 10)
		)
		receiveButton.addTarget(self, action: #selector(openReceiveButtonVC), for: .touchUpInside)
		showBalanceButton.setConfiguraton(font: .PinoStyle.mediumFootnote!, imagePadding: 5)

		volatilityView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openVolatilityDetailPage)))
		balanceLabel
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activateSecurityMode)))
		showBalanceButton.addAction(UIAction(handler: { _ in
			self.activateSecurityMode()
		}), for: .touchUpInside)

		showBalanceButton.isHidden = true
		volatilityDetailButton.isHidden = true
	}

	private func setSkeletonable() {
		balanceLabel.isSkeletonable = true
		volatilityView.isSkeletonable = true
	}

	private func setupBindings() {
		let volatilityViewWidthConstraint = volatilityView.widthAnchor.constraint(equalToConstant: 132)
		homeVM.$walletBalance.sink { [weak self] walletBalance in
			guard let self = self else { return }
			guard let walletBalance = walletBalance else {
				volatilityViewWidthConstraint.isActive = true
				return
			}
			volatilityViewWidthConstraint.isActive = false
			self.balanceLabel.text = walletBalance.balance
			self.volatilityPercentageLabel.text = walletBalance.volatilityPercentage
			self.volatilityInDollarLabel.text = walletBalance.volatilityInDollor

			var volatilityViewBackgroundColor: UIColor!
			var volatilityViewTintColor: UIColor!
			var volatilityDetailIcon: String
			switch walletBalance.volatilityType {
			case .profit:
				volatilityDetailIcon = "arrow_right_green"
				volatilityViewBackgroundColor = .Pino.green1
				volatilityViewTintColor = .Pino.green3
			case .loss:
				volatilityDetailIcon = "arrow_right_red"
				volatilityViewBackgroundColor = .Pino.lightRed
				volatilityViewTintColor = .Pino.red
			case .none:
				volatilityDetailIcon = "arrow_right"
				volatilityViewBackgroundColor = .Pino.gray5
				volatilityViewTintColor = .Pino.green3
			}
			self.volatilityDetailButton.image = UIImage(named: volatilityDetailIcon)
			self.volatilityView.backgroundColor = volatilityViewBackgroundColor
			self.volatilitySeparatorLine.backgroundColor = volatilityViewTintColor
			self.volatilityPercentageLabel.textColor = volatilityViewTintColor
			self.volatilityInDollarLabel.textColor = volatilityViewTintColor
			self.volatilityDetailButton.tintColor = volatilityViewTintColor

			if walletBalance.securityMode {
				self.balanceLabel.font = .PinoStyle.boldBigTitle
				self.volatilityView.isHidden = true
				self.showBalanceButton.isHidden = false
			} else {
				self.balanceLabel.font = .PinoStyle.semiboldLargeTitle
				self.volatilityView.isHidden = false
				self.showBalanceButton.isHidden = true
			}

			if walletBalance.balanceModel.balance < 0.bigNumber {
				self.volatilityDetailButton.isHidden = true
				self.volatilityView.isUserInteractionEnabled = false
			} else {
				self.volatilityDetailButton.isHidden = false
				self.volatilityView.isUserInteractionEnabled = true
			}
			self.updateConstraints()
		}
		.store(in: &cancellables)
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.bottom(padding: 32)
		)
		volatilityStackView.pin(
			.centerY,
			.horizontalEdges(padding: 12)
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

		volatilityDetailButton.pin(
			.fixedWidth(18),
			.fixedHeight(18)
		)

		NSLayoutConstraint.activate([
			balanceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 94),
			balanceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
			volatilityView.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
		])
	}

	@objc
	private func activateSecurityMode() {
		// Uncomment this line to enable security mode
//		homeVM.securityMode.toggle()
	}

	@objc
	private func openVolatilityDetailPage() {
		portfolioPerformanceTapped()
	}

	@objc
	private func openSendAssetVC() {
		sendButtonTappedClosure()
	}

	@objc
	private func openReceiveButtonVC() {
		receiveButtonTappedClosure()
	}
}
