//
//  CustomAssetInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class CustomAssetInfoView: UIView {
	// Typealias
	typealias presentTooltipAlertClosureType = (_ tooltipTitle: String, _ tooltipDescription: String) -> Void

	// MARK: - Closure

	var presentTooltipAlertClosure: presentTooltipAlertClosureType

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let nameItem: CustomAssetViewItem
	private var userBalanceItem: CustomAssetViewItem?
	private let websiteItem: CustomAssetViewItem
	private let contractAddressItem: CustomAssetViewItem

	private let nameLabel = PinoLabel(style: .info, text: "")
	private let userBalanceLabel = PinoLabel(style: .info, text: "")
	private let contractAddressLabel = PinoLabel(style: .info, text: "")
	private let websiteLabel = PinoLabel(style: .info, text: "")
	private var addCustomAssetVM: AddCustomAssetViewModel

	// MARK: - Initializers

	init(
		addCustomAssetVM: AddCustomAssetViewModel,
		presentTooltipAlertClosure: @escaping presentTooltipAlertClosureType
	) {
		self.addCustomAssetVM = addCustomAssetVM
		self.presentTooltipAlertClosure = presentTooltipAlertClosure

		self.nameItem = CustomAssetViewItem(
			titleText: addCustomAssetVM.customAssetNameItem.title,
			tooltipText: addCustomAssetVM.customAssetNameItem.tooltipText,
			infoView: nameLabel
		)
		self.websiteItem = CustomAssetViewItem(
			titleText: addCustomAssetVM.customAssetWebsiteItem.title,
			tooltipText: addCustomAssetVM.customAssetWebsiteItem.tooltipText,
			infoView: websiteLabel
		)
		self.contractAddressItem = CustomAssetViewItem(
			titleText: addCustomAssetVM.customAssetContractAddressItem.title,
			tooltipText: addCustomAssetVM.customAssetContractAddressItem.tooltipText,
			infoView: contractAddressLabel
		)

		super.init(frame: .zero)

		setupView()
		setupConstraints()
		setupClosures()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupClosures() {
		nameItem.presentTooltipAlertClosure = presentTooltipAlertClosure
		websiteItem.presentTooltipAlertClosure = presentTooltipAlertClosure
		contractAddressItem.presentTooltipAlertClosure = presentTooltipAlertClosure
		userBalanceItem?.presentTooltipAlertClosure = presentTooltipAlertClosure
	}

	private func setupView() {
		let customAsset = addCustomAssetVM.customAsset
		// Setup nameItem icon
		nameItem.infoIconName = customAsset?.icon

		// Setup asset name label
		nameLabel.text = customAsset?.name
		nameLabel.numberOfLines = 0
		nameLabel.lineBreakMode = .byWordWrapping

		// Setup asset website label
		websiteLabel.text = customAsset?.website
		websiteLabel.numberOfLines = 0
		websiteLabel.lineBreakMode = .byWordWrapping

		// Setup contract address label
		contractAddressLabel.text = customAsset?.contractAddress
		contractAddressLabel.lineBreakMode = .byTruncatingMiddle

		// Setup self view
		backgroundColor = .Pino.secondaryBackground
		layer.cornerRadius = 12

		// Setup stackview
		addSubview(mainStackView)
		mainStackView.axis = .vertical
		mainStackView.spacing = 16
		mainStackView.addArrangedSubview(nameItem)
		if let userBalance = customAsset?.balance {
			userBalanceLabel.text = userBalance
			userBalanceLabel.numberOfLines = 0
			userBalanceLabel.lineBreakMode = .byWordWrapping
			userBalanceItem = CustomAssetViewItem(
				titleText: addCustomAssetVM.customAssetUserBalanceItem.title,
				tooltipText: addCustomAssetVM.customAssetUserBalanceItem.tooltipText,
				infoView: userBalanceLabel
			)
			guard let finalUserBalanceItem = userBalanceItem! as CustomAssetViewItem? else {
				return
			}
			mainStackView.addArrangedSubview(finalUserBalanceItem)
		}
		mainStackView.addArrangedSubview(websiteItem)
		mainStackView.addArrangedSubview(contractAddressItem)
	}

	private func setupConstraints() {
		mainStackView.pin(.horizontalEdges(to: superview, padding: 14), .verticalEdges(to: superview, padding: 18))
		contractAddressLabel.pin(.fixedWidth(92))
	}
}
