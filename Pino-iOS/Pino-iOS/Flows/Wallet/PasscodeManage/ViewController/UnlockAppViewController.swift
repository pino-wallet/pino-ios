//
//  EnterPasscodeViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/5/23.
//

import UIKit

class UnlockAppViewController: UIViewController {
	// MARK: - Public Properties

	public var onSuccessUnlock: () -> Void
	public var onFaceIDSelected: () -> Void

	// MARK: - Private Properties

	private var unlockAppVM: UnlockAppViewModel!
	private var managePasscodeView: UnlockPasscodeView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		managePasscodeView?.passDotsView.becomeFirstResponder()
	}

	// MARK: - Initializers

	init(onSuccessUnlock: @escaping () -> Void, onFaceIDSelected: @escaping () -> Void) {
		self.onSuccessUnlock = onSuccessUnlock
		self.onFaceIDSelected = onFaceIDSelected
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		setupUnlockAppVM()
		managePasscodeView = UnlockPasscodeView(
			managePassVM: unlockAppVM,
			onFaceIDSelected: {
				self.onFaceIDSelected()
			}
		)
		checkIfUserHasFaceID()
		view = managePasscodeView
	}

	private func setupUnlockAppVM() {
		unlockAppVM = UnlockAppViewModel(
			onClearError: { [weak self] in
				self?.managePasscodeView.hideError()
			}, onErrorHandling: { [weak self] error in
				switch error {
				case .dontMatch:
					self?.managePasscodeView.passDotsView.showErrorState()
					self?.managePasscodeView.showErrorWith(text: (self?.unlockAppVM.dontMatchErrorText)!)
				case .getPasswordFailed:
					fatalError("Failed to get user passcode")
				case .emptyPasscode:
					fatalError("Passcode is empty")
				}
			}, onSuccessUnlock: { [weak self] in
				self?.onSuccessLogin()
			}
		)
	}

	private func checkIfUserHasFaceID() {
		// check if user has face id
		let showBiometricOptionCount = UserDefaults.standard
			.integer(forKey: GlobalUserDefaultsKeys.showBiometricCounts.key)
		if showBiometricOptionCount == 0 {
			UserDefaults.standard.setValue(showBiometricOptionCount + 1, forKey: GlobalUserDefaultsKeys.showBiometricCounts.key)
			managePasscodeView.hasFaceIDMode = true
		} else {
			managePasscodeView.hasFaceIDMode = false
		}
	}

	private func onSuccessLogin() {
		onSuccessUnlock()
		dismiss(animated: true)
	}
}
