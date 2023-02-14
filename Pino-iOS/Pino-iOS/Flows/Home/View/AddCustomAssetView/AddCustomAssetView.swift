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
	private let addButton = PinoButton(style: .active, title: "")
	private let scanQRCodeIconButton = UIButton()
	private let pasteFromClipboardview =
		PasteFromClipboardView(contractAddress: "")
	private var customAssetInfoView: CustomAssetInfoView?
	private lazy var dissmissKeyboardTapGesture = UITapGestureRecognizer(
		target: self,
		action: #selector(dissmissKeyboard(_:))
	)
	private var addCustomAssetVM: AddCustomAssetViewModel

	// MARK: - Initializers

	init(
		presentTooltipAlertClosure: @escaping presentTooltipAlertClosureType,
		dissmissKeybaordClosure: @escaping dissmissKeyboardClosureType,
		addCustomAssetVM: AddCustomAssetViewModel
	) {
		self.presentTooltipAlertClosure = presentTooltipAlertClosure
		self.dissmissKeyboardClosure = dissmissKeybaordClosure
		self.addCustomAssetVM = addCustomAssetVM
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addButton.title = addCustomAssetVM.addCustomAssetButtonTitle

		pasteFromClipboardview.contractAddress = addCustomAssetVM.customAsset.contractAddress

		addGestureRecognizer(dissmissKeyboardTapGesture)
		customAssetInfoView = CustomAssetInfoView(
			addCustomAssetVM: addCustomAssetVM,
			presentTooltipAlertClosure: presentTooltipAlertClosure
		)
		// Setup subviews
		addSubview(addButton)
		addSubview(contractTextfieldView)
//		addSubview(pasteFromClipboardview)
		addSubview(customAssetInfoView!)
		// Setup contract text field view
		contractTextfieldView.placeholderText = addCustomAssetVM.addCustomAssetTextfieldPlaceholder
		contractTextfieldView.returnKeyType = .search
		contractTextfieldView.textFieldKeyboardOnReturn = dissmissKeyboardClosure
		scanQRCodeIconButton.setImage(UIImage(named: addCustomAssetVM.addCustomAssetTextfieldIcon), for: .normal)
		contractTextfieldView.style = .customIcon(scanQRCodeIconButton)
		contractTextfieldView.errorText = addCustomAssetVM.addCustomAssetTextfieldError
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
