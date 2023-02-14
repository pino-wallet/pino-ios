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
	private let nameView: CustomAssetView
	private var userBalanceView: CustomAssetView?
	private let websiteView: CustomAssetView
	private let contractAddressView: CustomAssetView

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

		self.nameView = CustomAssetView(
			titleText: addCustomAssetVM.customAssetNameItem.title,
			tooltipText: addCustomAssetVM.customAssetNameItem.tooltipText,
			infoView: nameLabel
		)
		self.websiteView = CustomAssetView(
			titleText: addCustomAssetVM.customAssetWebsiteItem.title,
			tooltipText: addCustomAssetVM.customAssetWebsiteItem.tooltipText,
			infoView: websiteLabel
		)
		self.contractAddressView = CustomAssetView(
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
		nameView.presentTooltipAlertClosure = presentTooltipAlertClosure
		websiteView.presentTooltipAlertClosure = presentTooltipAlertClosure
		contractAddressView.presentTooltipAlertClosure = presentTooltipAlertClosure
		userBalanceView?.presentTooltipAlertClosure = presentTooltipAlertClosure
	}

	private func setupView() {
		let customAsset = addCustomAssetVM.customAsset
		// Setup nameItem icon
		nameView.infoIconName = customAsset?.icon

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
		mainStackView.addArrangedSubview(nameView)
		if let userBalance = customAsset?.balance {
			userBalanceLabel.text = userBalance
			userBalanceLabel.numberOfLines = 0
			userBalanceLabel.lineBreakMode = .byWordWrapping
			userBalanceView = CustomAssetView(
				titleText: addCustomAssetVM.customAssetUserBalanceItem.title,
				tooltipText: addCustomAssetVM.customAssetUserBalanceItem.tooltipText,
				infoView: userBalanceLabel
			)

			mainStackView.addArrangedSubview(userBalanceView!)
		}
		mainStackView.addArrangedSubview(websiteView)
		mainStackView.addArrangedSubview(contractAddressView)
	}

	private func setupConstraints() {
		mainStackView.pin(.horizontalEdges(to: superview, padding: 14), .verticalEdges(to: superview, padding: 18))
		contractAddressLabel.pin(.fixedWidth(92))
	}
}
