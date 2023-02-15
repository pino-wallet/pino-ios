//
//  AddCustomAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import NotificationCenter
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
		validateContractAddressFromClipboard()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(detectClipboardText),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
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
//		addSubview(customAssetInfoView!)
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

//		customAssetInfoView?.pin(.relative(.top, 16, to: contractTextfieldView, .bottom), .horizontalEdges(
//			to:
//			layoutMarginsGuide,
//			padding: 0
//		))
	}

	private func validateContractAddressFromClipboard() {
		guard let clipboardText = UIPasteboard.general.string else {
			return
		}
		addCustomAssetVM.setupPasteFromClipboardViewClosure = { [weak self] validatedContractAddressVM in
			self?.customAssetInfoView?.removeFromSuperview()
			self?.pasteFromClipboardview.contractAddress = validatedContractAddressVM.finalValidatedAddress
			self?.addSubview(self?.pasteFromClipboardview ?? UIView())
			self?.setupPasteFromClipboardViewConstraints()
			self?.pasteFromClipboardview.onPaste = onPasteFromClipboardButtonTap

			func onPasteFromClipboardButtonTap() {
				self?.contractTextfieldView.textFieldText = clipboardText
				self?.pasteFromClipboardview.removeFromSuperview()
			}
		}
		addCustomAssetVM.validateContractAddressFromClipboard(clipboardText: clipboardText)
	}

	private func setupPasteFromClipboardViewConstraints() {
		pasteFromClipboardview.pin(
			.relative(.top, 8, to: contractTextfieldView, .bottom),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
	}

	@objc
	private func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
		dissmissKeyboardClosure()
	}

	@objc
	private func detectClipboardText() {
		validateContractAddressFromClipboard()
	}
}
