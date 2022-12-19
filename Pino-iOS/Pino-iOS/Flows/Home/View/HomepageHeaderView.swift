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
	private var assetStackView = UIStackView()
	private var assetLabel = UILabel()
	private var profitStackView = UIStackView()
	private var profitView = UIView()
	private var profitPercentageLabel = UILabel()
	private var profitInDollarLabel = UILabel()
	private var profitSeparatorLine = UIView()
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
		assetStackView.addArrangedSubview(assetLabel)
		assetStackView.addArrangedSubview(profitView)
		profitStackView.addArrangedSubview(profitPercentageLabel)
		profitStackView.addArrangedSubview(profitSeparatorLine)
		profitStackView.addArrangedSubview(profitInDollarLabel)
		profitView.addSubview(profitStackView)
		sendRecieveStackView.addArrangedSubview(sendButton)
		sendRecieveStackView.addArrangedSubview(recieveButton)
		contentStackView.addArrangedSubview(assetStackView)
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

		profitView.backgroundColor = .Pino.green1
		profitSeparatorLine.backgroundColor = .Pino.green3

		assetLabel.textColor = .Pino.label
		profitPercentageLabel.textColor = .Pino.green3
		profitInDollarLabel.textColor = .Pino.green3

		assetLabel.font = .PinoStyle.semiboldTitle1
		profitPercentageLabel.font = .PinoStyle.semiboldFootnote
		profitInDollarLabel.font = .PinoStyle.semiboldFootnote

		contentStackView.axis = .vertical
		assetStackView.axis = .vertical
		profitStackView.axis = .horizontal
		sendRecieveStackView.axis = .horizontal

		contentStackView.spacing = 25
		assetStackView.spacing = 10
		sendRecieveStackView.spacing = 24
		profitStackView.spacing = 6

		contentStackView.alignment = .center
		assetStackView.alignment = .center
		sendRecieveStackView.distribution = .fillEqually

		profitView.layer.cornerRadius = 14

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
		homeVM.$assetInfo.sink { [weak self] assetInfo in
			self?.assetLabel.text = assetInfo?.amount
			self?.profitPercentageLabel.text = assetInfo?.profitPercentage
			self?.profitInDollarLabel.text = assetInfo?.profitInDollor
			self?.updateConstraints()
		}
		.store(in: &cancellables)
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 27)
		)
		profitStackView.pin(
			.centerY,
			.horizontalEdges(padding: 12)
		)
		profitView.pin(
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

		profitSeparatorLine.pin(
			.fixedWidth(0.6),
			.verticalEdges
		)
	}
}
