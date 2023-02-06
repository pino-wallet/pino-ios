//
//  CustomAssetInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class CustomAssetInfoView: UIView {
	// MARK: - Public Properties

	public var assetName: String
	public var assetIconName: String
	public var userBalance: Double?
	public var assetWebsite: String
	public var assetContractAddress: String

	// MARK: - Private Properties

	private let stackView = UIStackView()
	#warning("These tooltip messages are for testing and should be changed")
	private let nameItem: CustomAssetViewItem
	private var userBalanceItem: CustomAssetViewItem?
	private let websiteItem: CustomAssetViewItem
	private let contractAddressItem: CustomAssetViewItem

	init(
		assetName: String,
		assetIcon: String,
		userBalance: Double?,
		assetWebsite: String,
		assetContractAddress: String
	) {
		self.assetName = assetName
		self.assetIconName = assetIcon
		self.userBalance = userBalance
		self.assetWebsite = assetWebsite
		self.assetContractAddress = assetContractAddress

		self.nameItem = CustomAssetViewItem(
			titleText: "Name",
			tooltipText: "Sample text",
			infoView: PinoLabel(style: .info, text: assetName)
		)
		self.websiteItem = CustomAssetViewItem(
			titleText: "Website",
			tooltipText: "Sample text",
			infoView: PinoLabel(style: .info, text: assetWebsite)
		)
		self.contractAddressItem = CustomAssetViewItem(
			titleText: "Contract address",
			tooltipText: "Sample text",
			infoView: PinoLabel(style: .info, text: String.minimizeText(text: assetContractAddress, textCount: 4))
		)

		super.init(frame: .zero)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		// Setup nameItem icon
		nameItem.infoIconName = assetIconName

		// Setup self view
		backgroundColor = .Pino.secondaryBackground
		layer.cornerRadius = 12

		// Setup stackview
		addSubview(stackView)
		stackView.axis = .vertical
		stackView.spacing = 16
		stackView.addArrangedSubview(nameItem)
		if let userBalance = userBalance {
			userBalanceItem = CustomAssetViewItem(
				titleText: "Your balance",
				tooltipText: "Sample text",
				infoView: PinoLabel(style: .info, text: String(describing: userBalance))
			)
			guard let finalUserBalanceItem = userBalanceItem! as CustomAssetViewItem? else {
				return
			}
			stackView.addArrangedSubview(finalUserBalanceItem)
		}
		stackView.addArrangedSubview(websiteItem)
		stackView.addArrangedSubview(contractAddressItem)
	}

	private func setupConstraints() {
		stackView.pin(.horizontalEdges(to: superview, padding: 14), .verticalEdges(to: superview, padding: 18))
	}
}
