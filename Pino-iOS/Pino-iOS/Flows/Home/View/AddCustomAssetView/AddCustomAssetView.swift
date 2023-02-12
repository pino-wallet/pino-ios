//
//  AddCustomAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetView: UIView {
	// Typealias
	typealias presentTooltipAlertClosureType = (_ tooltipTitle: String, _ tooltipDescription: String) -> Void
	typealias dissmissKeyboardClosureType = () -> Void

	// MARK: - Closure

	var presentTooltipAlertClosure: presentTooltipAlertClosureType
	var dissmissKeyboardClosure: dissmissKeyboardClosureType

	// MARK: - Private Properties

	private let contractTextfieldView = PinoTextFieldView()
	private let addButton = PinoButton(style: .active, title: "Add")
	private let scanQRCodeIconButton = UIButton()
	private let pasteFromClipboardview =
		PasteFromClipboardView(contractAddress: "0x4108A1698EDB3d3E66aAD93E030dbF28Ea5ABB11")
	private var customAssetInfoView: CustomAssetInfoView?
	private lazy var dissmissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard(_:)))

	init(
		presentTooltipAlertClosure: @escaping presentTooltipAlertClosureType,
		dissmissKeybaordClosure: @escaping dissmissKeyboardClosureType
	) {
		self.presentTooltipAlertClosure = presentTooltipAlertClosure
		self.dissmissKeyboardClosure = dissmissKeybaordClosure
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addGestureRecognizer(dissmissTapGesture)
		customAssetInfoView = CustomAssetInfoView(
			assetName: "USDC",
			assetIcon: "USDC",
			userBalance: 230.1,
			assetWebsite: "www.usdc.com",
			assetContractAddress: "0x4108A1698EDB3d3E66aAD93E030dbF28Ea5ABB11",
			presentTooltipAlertClosure: presentTooltipAlertClosure
		)
		// Setup subviews
		addSubview(addButton)
		addSubview(contractTextfieldView)
//		addSubview(pasteFromClipboardview)
		addSubview(customAssetInfoView ?? UIView())
		// Setup contract text field view
		contractTextfieldView.placeholderText = "Enter contract address"
		contractTextfieldView.returnKeyType = .Search
		contractTextfieldView.textFieldKeyboardOnReturn = dissmissKeyboardClosure
		scanQRCodeIconButton.setImage(UIImage(named: "qr_code_scanner"), for: .normal)
		contractTextfieldView.style = .pending
		#warning("error text is for test and should be change")
		contractTextfieldView.errorText = "This is an error!"
	}

	private func setupConstraints() {
		contractTextfieldView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
		addButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 0),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
//		pasteFromClipboardview.pin(
//			.relative(.top, 8, to: contractTextfieldView, .bottom),
//			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
//		)
		customAssetInfoView?.pin(.relative(.top, 16, to: contractTextfieldView, .bottom), .horizontalEdges(
			to:
			layoutMarginsGuide,
			padding: 0
		))
	}

	@objc
	private func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
		dissmissKeyboardClosure()
	}
}
