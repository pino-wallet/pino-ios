//
//  AddCustomAssetViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import NotificationCenter
import UIKit

class AddCustomAssetViewController: UIViewController {
	// MARK: - Public Properties

	public var homeVM: HomepageViewModel

	// MARK: - Private Properties

	private let addCustomAssetVM = AddCustomAssetViewModel()

	// MARK: - Initializers

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		super.init(nibName: nil, bundle: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(validateClipboardTextAfterAppDidBecomeActive),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewDidAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			validateClipboardText()
		}
	}

	// MARK: - Deinit

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Private Methods

	private func setupView() {
		addCustomAssetVM.homeVM = homeVM
		let addCustomAssetView =
			AddCustomAssetView(
				presentAlertClosure: { [weak self] alertTitle, alertDescription in
					let alert = InfoActionSheet(title: alertTitle, description: alertDescription)
					self?.present(alert, animated: true)
				},
				dissmissKeybaordClosure: { [weak self] in
					self?.view.endEditing(true)
				},
				addCustomAssetVM: addCustomAssetVM,
				toggleNavigationRightButtonEnabledClosure: { [weak self] isEnabled in
					self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
				}
			)
		view = addCustomAssetView
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup navigation title
		setNavigationTitle(addCustomAssetVM.addcustomAssetPageTitle)

		// Setup dismiss button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: addCustomAssetVM.addCustomAssetPageBackButtonIcon), style: .plain, target: self,
			action: #selector(dismissAddCustomAssetVC)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white

		// Setup add button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: addCustomAssetVM.addCustomAssetButtonTitle,
			style: .plain,
			target: self,
			action: #selector(addCustomAssetHandler)
		)
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(
			[NSAttributedString.Key.foregroundColor: UIColor.Pino.gray2],
			for: .disabled
		)
	}

	private func validateClipboardText() {
		guard let clipboardText = UIPasteboard.general.string else {
			return
		}
		addCustomAssetVM.validateContractAddressFromClipboard(clipboardText: clipboardText)
	}

	// Setup dismiss button handler
	@objc
	private func dismissAddCustomAssetVC() {
		dismiss(animated: true)
	}

	// Setup add button handler
	@objc
	private func addCustomAssetHandler() {
		print("added")
	}

	@objc
	private func validateClipboardTextAfterAppDidBecomeActive() {
		validateClipboardText()
	}
}
