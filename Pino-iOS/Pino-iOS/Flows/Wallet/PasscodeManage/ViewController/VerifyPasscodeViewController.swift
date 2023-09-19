//
//  VerifyPasscodeViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/20/22.
//

import UIKit

class VerifyPasscodeViewController: UIViewController {
	// MARK: Private Properties

	private var selectedAccounts: [ActiveAccountViewModel]?
	private var mnemonics: String?

	// MARK: Public Properties

	public var verifyPassView: ManagePasscodeView?
	public var verifyPassVM: VerifyPassViewModel!
	public var selectedPasscode = ""

	// MARK: Initializers

	init(selectedAccounts: [ActiveAccountViewModel]?, mnemonics: String?) {
		self.selectedAccounts = selectedAccounts
		self.mnemonics = mnemonics
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		verifyPassView?.passDotsView.becomeFirstResponder()
	}

	override func loadView() {
		setupView()
		setSteperView(stepsCount: 3, curreuntStep: 3)
	}

	// MARK: Private Methods

	private func setupView() {
		// Custom view should be created
		configVerifyPassVM()
		verifyPassView = ManagePasscodeView(managePassVM: verifyPassVM)
		view = verifyPassView
		verifyPassView?.passDotsView.becomeFirstResponder()
	}

	func configVerifyPassVM() {
		verifyPassVM = VerifyPassViewModel(
			finishPassCreation: {
				// Passcode was verified -> Show all done page
				let allDoneVC = AllDoneViewController(
					selectedAccounts: self.selectedAccounts,
					mnemonics: self.mnemonics
				)
				self.navigationController?.pushViewController(allDoneVC, animated: true)
			},
			onErrorHandling: { error in
				// display error
				switch error {
				case .dontMatch:
					self.verifyPassView?.passDotsView.showErrorState()
					self.verifyPassView?.showErrorWith(text: self.verifyPassVM.errorTitle)
				case .saveFailed:
					fatalError("Print Failed")
				case .unknown:
					fatalError("Uknown Error")
				case .emptyPasscode:
					fatalError("Passcode sent to verify is empty")
				}
			},
			hideError: {
				self.verifyPassView?.hideError()
			},
			selectedPasscode: selectedPasscode
		)
	}
}
