//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import UIKit

class HomepageHeaderView: UICollectionReusableView {
	public static let headerReuseID = "homepgaeHeader"

	public var contentStackView = UIStackView()
	public var assetStackView = UIStackView()
	public var assetLabel = UILabel()
	public var profitStackView = UIStackView()
	public var profitView = UIView()
	public var profitPercentageLabel = UILabel()
	public var profitInDollarLabel = UILabel()
	public var profitSeparatorLine = UIView()
	public var sendRecieveStackView = UIStackView()
	public var sendButton = PinoButton(style: .active)
	public var recieveButton = PinoButton(style: .secondary)

	public var asset: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

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
		assetLabel.text = "$12,568,000"
		profitPercentageLabel.text = "+5.6%"
		profitInDollarLabel.text = "+$58.67"

		sendButton.title = "Send"
		recieveButton.title = "Recieve"

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
