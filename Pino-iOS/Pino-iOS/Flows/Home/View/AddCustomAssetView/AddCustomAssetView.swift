//
//  AddCustomAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetView: UIView {
	// Typealias
	typealias presentAlertClosureType = (_ alertTitle: String, _ alertDescription: String) -> Void
	typealias dissmissKeyboardClosureType = () -> Void

	// MARK: - Closure

	var presentAlertClosure: presentAlertClosureType
	var dissmissKeyboardClosure: dissmissKeyboardClosureType

	// MARK: - Private Properties

	private let contractTextfieldView = PinoTextFieldView()
	private let addButton = PinoButton(style: .active, title: "")
	private let scanQRCodeIconButton = UIButton()
	private let pasteFromClipboardview =
		PasteFromClipboardView(contractAddress: "")
	private var customAssetInfoView: CustomAssetInfoContainerView?
	private lazy var dissmissKeyboardTapGesture = UITapGestureRecognizer(
		target: self,
		action: #selector(dissmissKeyboard(_:))
	)
	private var addCustomAssetVM: AddCustomAssetViewModel

	// MARK: - Initializers

	init(
		presentAlertClosure: @escaping presentAlertClosureType,
		dissmissKeybaordClosure: @escaping dissmissKeyboardClosureType,
		addCustomAssetVM: AddCustomAssetViewModel
	) {
		self.presentAlertClosure = presentAlertClosure
		self.dissmissKeyboardClosure = dissmissKeybaordClosure
		self.addCustomAssetVM = addCustomAssetVM
		super.init(frame: .zero)
		setupView()
		setupConstraints()
		setupPasteFromClipboardClosure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addButton.title = addCustomAssetVM.addCustomAssetButtonTitle

		addGestureRecognizer(dissmissKeyboardTapGesture)
		customAssetInfoView = CustomAssetInfoContainerView(
			addCustomAssetVM: addCustomAssetVM,
			presentAlertClosure: presentAlertClosure
		)
		// Setup subviews
		addSubview(addButton)
		addSubview(contractTextfieldView)
		addSubview(pasteFromClipboardview)
//		addSubview(customAssetInfoView!)
		// Setup contract text field view
		contractTextfieldView.placeholderText = addCustomAssetVM.addCustomAssetTextfieldPlaceholder
		contractTextfieldView.returnKeyType = .search
		contractTextfieldView.textFieldKeyboardOnReturn = dissmissKeyboardClosure
		scanQRCodeIconButton.setImage(UIImage(named: addCustomAssetVM.addCustomAssetTextfieldIcon), for: .normal)
		contractTextfieldView.style = .customIcon(scanQRCodeIconButton)
		contractTextfieldView.errorText = addCustomAssetVM.addCustomAssetTextfieldError
		// Setup pasteFromClipboardView
		pasteFromClipboardview.isHidden = true
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
		pasteFromClipboardview.pin(
			.relative(.top, 8, to: contractTextfieldView, .bottom),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)

//		customAssetInfoView?.pin(.relative(.top, 16, to: contractTextfieldView, .bottom), .horizontalEdges(
//			to:
//			layoutMarginsGuide,
//			padding: 0
//		))
	}

	private func setupPasteFromClipboardClosure() {
		addCustomAssetVM.setupPasteFromClipboardViewClosure = { [weak self] validatedAddress in
			self?.pasteFromClipboardview.contractAddress = validatedAddress
			self?.pasteFromClipboardview.isHidden = false
			self?.pasteFromClipboardview.onPaste = {
				self?.contractTextfieldView.textFieldText = validatedAddress
				self?.pasteFromClipboardview.isHidden = true
			}
		}
	}

	@objc
	private func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
		dissmissKeyboardClosure()
	}
}
