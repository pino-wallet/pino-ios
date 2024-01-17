//
//  AddCustomAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

class AddCustomAssetView: UIView {

	// MARK: - Typealias
	typealias PresentAlertClosureType = (_ alertTitle: String, _ alertDescription: String) -> Void
	typealias DissmissKeyboardClosureType = () -> Void
	typealias ToggleNavigationRightButtonEnabledClosureType = (_ isEnabled: Bool) -> Void
    typealias PresentScannerVCType = (_ scannerVC: ScannerViewController) -> Void

	// MARK: - Closure

	private var presentAlertClosure: PresentAlertClosureType
	private var dissmissKeyboardClosure: DissmissKeyboardClosureType
	private var toggleNavigationRightButtonEnabledClosure: ToggleNavigationRightButtonEnabledClosureType
    private var presentScannerVC: PresentScannerVCType

	// MARK: - Private Properties
    
    private enum viewStatuses {
        case clearView
        case errorView(String)
        case pendingView
        case pasteFromClipboardView
        case successView
    }

	private let contractTextfieldView = PinoTextFieldView(pattern: nil)
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

	private let addButtonTapped: () -> Void
    private var scannerQRCodeVC: ScannerViewController!

	// MARK: - Initializers

	init(
		presentAlertClosure: @escaping PresentAlertClosureType,
		dissmissKeybaordClosure: @escaping DissmissKeyboardClosureType,
		addCustomAssetVM: AddCustomAssetViewModel,
		toggleNavigationRightButtonEnabledClosure: @escaping ToggleNavigationRightButtonEnabledClosureType,
		addButtonTapped: @escaping () -> Void,
        presentScannerVC: @escaping PresentScannerVCType
	) {
		self.presentAlertClosure = presentAlertClosure
		self.dissmissKeyboardClosure = dissmissKeybaordClosure
		self.addCustomAssetVM = addCustomAssetVM
		self.toggleNavigationRightButtonEnabledClosure = toggleNavigationRightButtonEnabledClosure
		self.addButtonTapped = addButtonTapped
        self.presentScannerVC = presentScannerVC
		super.init(frame: .zero)
		setupView()
		setupConstraints()
		setupChangeStatusClosure()
		switchViewStatus()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
        scanQRCodeIconButton.addTarget(self, action: #selector(openScannerQRCodeVC), for: .touchUpInside)
        
        scannerQRCodeVC = ScannerViewController(getScanResult: { scanResult in
            self.contractTextfieldView.text = scanResult
            self.addCustomAssetVM.validateContractAddressBeforeRequest(
                textFieldText: self.contractTextfieldView.text ?? ""
            )
        })
        
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
			self?.addCustomAssetVM.validateContractAddressBeforeRequest(
				textFieldText: self?.contractTextfieldView.getText() ?? ""
			)
		}
		scanQRCodeIconButton.setImage(UIImage(named: addCustomAssetVM.addCustomAssetTextfieldIcon), for: .normal)
		contractTextfieldView.style = .customView(scanQRCodeIconButton)
		// Setup pasteFromClipboardView
		pasteFromClipboardview.isHidden = true

		addButton.addAction(UIAction(handler: { _ in
			self.addButtonTapped()
		}), for: .touchUpInside)
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
			guard let self else { return }
			switch currentStatus {
			case .clear:
				self.viewStatus = .clearView
			case let .pasteFromClipboard(validatedContractAddress):
				self.pasteFromClipboardview.contractAddress = validatedContractAddress
				self.viewStatus = .pasteFromClipboardView
				self.pasteFromClipboardview.onPaste = {
					self.contractTextfieldView.text = validatedContractAddress
					self.addCustomAssetVM.validateContractAddressBeforeRequest(
						textFieldText: self.contractTextfieldView.text ?? ""
					)
				}
			case .pending:
				self.viewStatus = .pendingView
			case let .error(error):
				self.viewStatus = .errorView(error.description)
			case .success:
				self.customAssetInfoView?.addCustomAssetVM = self.addCustomAssetVM
				self.viewStatus = .successView
			}
		}
	}

	private func switchViewStatus() {
		toggleNavigationRightButtonEnabledClosure(false)
		addButton.style = .deactive
		switch viewStatus {
		case .clearView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .customView(scanQRCodeIconButton)
			addButton.title = addCustomAssetVM.addCustomAssetButtonTitle

		case let .errorView(errorText):
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .error
			addButton.title = errorText

		case .pendingView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = true
			contractTextfieldView.style = .pending
			addButton.title = addCustomAssetVM.addCustomAssetLoadingButtonTitle

		case .pasteFromClipboardView:
			customAssetInfoView?.isHidden = true
			pasteFromClipboardview.isHidden = false
			contractTextfieldView.style = .customView(scanQRCodeIconButton)
			addButton.title = addCustomAssetVM.addCustomAssetButtonTitle

		case .successView:
			pasteFromClipboardview.isHidden = true
			customAssetInfoView?.isHidden = false
			contractTextfieldView.style = .success
			addButton.style = .active
			toggleNavigationRightButtonEnabledClosure(true)
			addButton.title = addCustomAssetVM.addCustomAssetButtonTitle
		}
	}

	@objc
	private func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
		dissmissKeyboardClosure()
	}
    
    @objc private func openScannerQRCodeVC() {
        presentScannerVC(scannerQRCodeVC)
    }
}
