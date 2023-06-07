//
//  CustomAssetInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import Combine
import UIKit

class CustomAssetInfoContainerView: UIView {
	// Typealias
	typealias presentAlertClosureType = (_ alertTitle: String, _ alertDescription: String) -> Void

	// MARK: - Closure

	var presentAlertClosure: presentAlertClosureType

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let nameView: CustomAssetInfoView
	private let symbolView: CustomAssetInfoView
	private let decimalView: CustomAssetInfoView
	private var userBalanceView: CustomAssetInfoView

	private let nameLabel = PinoLabel(style: .info, text: "")
	private let symbolLabel = PinoLabel(style: .info, text: "")
	private let decimalLabel = PinoLabel(style: .info, text: "")
	private let userBalanceLabel = PinoLabel(style: .info, text: "")
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var addCustomAssetVM: AddCustomAssetViewModel {
		didSet {
			setupViewCustomValues()
		}
	}

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
		self.userBalanceView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetUserBalanceInfo.title,
			alertText: addCustomAssetVM.customAssetUserBalanceInfo.alertText,
			infoView: userBalanceLabel
		)
		self.symbolView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetSymbolInfo.title,
			alertText: addCustomAssetVM.customAssetSymbolInfo.alertText,
			infoView: symbolLabel
		)
		self.decimalView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetDecimalInfo.title,
			alertText: addCustomAssetVM.customAssetDecimalInfo.alertText,
			infoView: decimalLabel
		)

		super.init(frame: .zero)

		setupView()
		setupConstraints()
		setupClosures()
		setupViewCustomValues()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupClosures() {
		nameView.presentAlertClosure = presentAlertClosure
		symbolView.presentAlertClosure = presentAlertClosure
		decimalView.presentAlertClosure = presentAlertClosure
		userBalanceView.presentAlertClosure = presentAlertClosure
	}

	private func setupView() {
		// Setup asset name label
		nameLabel.numberOfLines = 0
		nameLabel.lineBreakMode = .byWordWrapping

		// Setup self view
		backgroundColor = .Pino.secondaryBackground
		layer.cornerRadius = 12

		// Setup UserBalanceView
		userBalanceLabel.numberOfLines = 0
		userBalanceLabel.lineBreakMode = .byWordWrapping
		userBalanceView = CustomAssetInfoView(
			titleText: addCustomAssetVM.customAssetUserBalanceInfo.title,
			alertText: addCustomAssetVM.customAssetUserBalanceInfo.alertText,
			infoView: userBalanceLabel
		)

		// Setup stackview
		addSubview(mainStackView)
		mainStackView.axis = .vertical
		mainStackView.spacing = 16
		mainStackView.addArrangedSubview(nameView)
		mainStackView.addArrangedSubview(symbolView)
		mainStackView.addArrangedSubview(decimalView)
		mainStackView.addArrangedSubview(userBalanceView)
	}

	private func setupViewCustomValues() {
		guard let customAsset = addCustomAssetVM.customAssetVM else { return }
		nameView.infoIconImage = UIImage(named: customAsset.icon)
		nameLabel.text = customAsset.name
		symbolLabel.text = customAsset.symbol
		decimalLabel.text = customAsset.decimal
		userBalanceLabel.text = customAsset.balance
	}

	private func setupConstraints() {
		mainStackView.pin(.horizontalEdges(to: superview, padding: 14), .verticalEdges(to: superview, padding: 18))
	}
}
