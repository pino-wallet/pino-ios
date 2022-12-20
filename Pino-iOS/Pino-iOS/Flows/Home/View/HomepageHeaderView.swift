//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import Combine
import UIKit

class HomepageHeaderView: UIView {
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
	private var homeVM: HomepageViewModel!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public static let headerReuseID = "homepgaeHeader"

	// MARK: - Initializers

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupBindings()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
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
		backgroundColor = .Pino.background

		sendButton.title = homeVM.sendButtonTitle
		recieveButton.title = homeVM.recieveButtonTitle

		sendButton.setImage(UIImage(systemName: homeVM.sendButtonImage), for: .normal)
		recieveButton.setImage(UIImage(systemName: homeVM.recieveButtonImage), for: .normal)

		sendButton.tintColor = .Pino.white
		recieveButton.tintColor = .Pino.primary

		balanceLabel.textColor = .Pino.label

		balanceLabel.font = .PinoStyle.semiboldTitle1
		volatilityPercentageLabel.font = .PinoStyle.semiboldFootnote
		volatilityInDollarLabel.font = .PinoStyle.semiboldFootnote

		contentStackView.axis = .vertical
		balanceStackView.axis = .vertical
		volatilityStackView.axis = .horizontal
		sendRecieveStackView.axis = .horizontal

		contentStackView.spacing = 25
		balanceStackView.spacing = 10
		sendRecieveStackView.spacing = 24
		volatilityStackView.spacing = 6

		contentStackView.alignment = .center
		balanceStackView.alignment = .center
		sendRecieveStackView.distribution = .fillEqually

		volatilityView.layer.cornerRadius = 14

		sendButton.configuration = .plain()
		recieveButton.configuration = .plain()
		sendButton.configuration?.imagePadding = 16
		recieveButton.configuration?.imagePadding = 16

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

	func setupBindings() {
		homeVM.$walletBalance.sink { [weak self] walletBalance in
			guard let walletBalance = walletBalance else { return }

			self?.balanceLabel.text = walletBalance.amount
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
			.top(to: layoutMarginsGuide, padding: 27)
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
}
