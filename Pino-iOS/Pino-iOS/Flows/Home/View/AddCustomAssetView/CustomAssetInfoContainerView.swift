//
//  CustomAssetInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class CustomAssetInfoContainerView: UIView {
	// Typealias
	typealias presentAlertClosureType = (_ alertTitle: String, _ alertDescription: String) -> Void

	// MARK: - Closure

	var presentAlertClosure: presentAlertClosureType

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let nameView: CustomAssetInfoView
	private var userBalanceView: CustomAssetInfoView?
	private let websiteView: CustomAssetInfoView
	private let contractAddressView: CustomAssetInfoView

	private let nameLabel = PinoLabel(style: .info, text: "")
	private let userBalanceLabel = PinoLabel(style: .info, text: "")
	private let contractAddressLabel = PinoLabel(style: .info, text: "")
	private let websiteLabel = PinoLabel(style: .info, text: "")
	private var addCustomAssetVM: AddCustomAssetViewModel

	// MARK: - Initializers

	init(
		addCustomAssetVM: AddCustomAssetViewModel,
		presentAlertClosure: @escaping presentAlertClosureType
	) {
		self.addCustomAssetVM = addCustomAssetVM
		self.presentAlertClosure = presentAlertClosure

		self.nameView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetNameInfo.title,
			alertText: addCustomAssetVM.customAssetNameInfo.alertText,
			infoView: nameLabel
		)
		self.websiteView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetWebsiteInfo.title,
			alertText: addCustomAssetVM.customAssetWebsiteInfo.alertText,
			infoView: websiteLabel
		)
		self.contractAddressView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetContractAddressInfo.title,
			alertText: addCustomAssetVM.customAssetContractAddressInfo.alertText,
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
		nameView.presentAlertClosure = presentAlertClosure
		websiteView.presentAlertClosure = presentAlertClosure
		contractAddressView.presentAlertClosure = presentAlertClosure
		userBalanceView?.presentAlertClosure = presentAlertClosure
	}

	private func setupView() {
		let customAsset = addCustomAssetVM.customAsset
		// Setup nameItem icon
		nameView.infoIconImage = UIImage(named: customAsset.icon)

		// Setup asset name label
		nameLabel.text = customAsset.name
		nameLabel.numberOfLines = 0
		nameLabel.lineBreakMode = .byWordWrapping

		// Setup asset website label
		websiteLabel.text = customAsset.website
		websiteLabel.numberOfLines = 0
		websiteLabel.lineBreakMode = .byWordWrapping

		// Setup contract address label
		contractAddressLabel.text = customAsset.contractAddress
		contractAddressLabel.lineBreakMode = .byTruncatingMiddle

		// Setup self view
		backgroundColor = .Pino.secondaryBackground
		layer.cornerRadius = 12

		// Setup stackview
		addSubview(mainStackView)
		mainStackView.axis = .vertical
		mainStackView.spacing = 16
		mainStackView.addArrangedSubview(nameView)
		if let userBalance = customAsset.balance {
			userBalanceLabel.text = userBalance
			userBalanceLabel.numberOfLines = 0
			userBalanceLabel.lineBreakMode = .byWordWrapping
			userBalanceView = CustomAssetInfoView(
				titleText: addCustomAssetVM.customAssetUserBalanceInfo.title,
				alertText: addCustomAssetVM.customAssetUserBalanceInfo.alertText,
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
