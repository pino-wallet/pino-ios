//
//  AddCustomAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetView: UIView {
	// Private Enum
	private enum viewStatuses {
		case clearView
		case errorView
		case pendingView
		case pasteFromClipboardView
		case successView
	}

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
	private var viewStatus: viewStatuses = .clearView {
		didSet {
			switchViewStatus()
		}
	}

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
		setupChangeStatusClosure()
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
		customAssetInfoView?.isHidden = true
		// Setup subviews
		addSubview(addButton)
		addSubview(contractTextfieldView)
		addSubview(pasteFromClipboardview)
		addSubview(customAssetInfoView!)
		// Setup contract text field view
		contractTextfieldView.placeholderText = addCustomAssetVM.addCustomAssetTextfieldPlaceholder
		contractTextfieldView.returnKeyType = .search
		contractTextfieldView.textFieldKeyboardOnReturn = dissmissKeyboardClosure
		contractTextfieldView.textDidChange = { [weak self] in
			self?.addCustomAssetVM.validateContractAddressFromTextField(
				textFieldText: self?.contractTextfieldView.getText() ?? "",
				delay: .small
			)
		}
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

		customAssetInfoView?.pin(.relative(.top, 16, to: contractTextfieldView, .bottom), .horizontalEdges(
			to:
			layoutMarginsGuide,
			padding: 0
		))
	}

	private func setupChangeStatusClosure() {
		addCustomAssetVM.changeViewStatusClosure = { [weak self] currentStatus in
			switch currentStatus {
			case .clear:
				self?.viewStatus = .clearView
			case let .pasteFromClipboard(validatedContractAddress):
				self?.pasteFromClipboardview.contractAddress = validatedContractAddress
				self?.viewStatus = .pasteFromClipboardView
				self?.pasteFromClipboardview.onPaste = {
					self?.contractTextfieldView.text = validatedContractAddress
					self?.addCustomAssetVM.validateContractAddressFromTextField(
						textFieldText: self?.contractTextfieldView.text ?? "",
						delay: .none
					)
				}
			case .pending:
				self?.viewStatus = .pendingView
			case let .error(error):
				self?.contractTextfieldView.errorText = error.description
				self?.viewStatus = .errorView
			case .success:
				self?.customAssetInfoView?.newAddCustomAssetVM = self?.addCustomAssetVM
				self?.viewStatus = .successView
			}
		}
	}

	private func switchViewStatus() {
		switch viewStatus {
		case .clearView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .customIcon(scanQRCodeIconButton)

		case .errorView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .error

		case .pendingView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .pending

		case .pasteFromClipboardView:
			customAssetInfoView?.isHidden = true
			pasteFromClipboardview.isHidden = false
			contractTextfieldView.style = .customIcon(scanQRCodeIconButton)

		case .successView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = false
			contractTextfieldView.style = .success
		}
	}

	@objc
	private func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
		dissmissKeyboardClosure()
	}
}
