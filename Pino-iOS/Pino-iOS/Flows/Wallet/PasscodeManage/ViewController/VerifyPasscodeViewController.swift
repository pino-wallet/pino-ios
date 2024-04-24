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
	private var mnemonics: String

	// MARK: Public Properties

	public var verifyPassView: ManagePasscodeView?
	public var verifyPassVM: VerifyPassViewModel!
	public var selectedPasscode = ""
	public var pageSteps: Int!
	public var currentStep: Int!

	// MARK: Initializers

	init(selectedAccounts: [ActiveAccountViewModel]?, mnemonics: String) {
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
		setSteperView(stepsCount: pageSteps, curreuntStep: currentStep)
	}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent, transitionCoordinator?.isInteractive == false {
            // code here
            HapticManager().run(type: .lightImpact)
        }
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
			finishPassCreation: { [self] in
				// Passcode was verified -> Show all done page
				if verifyPassVM.showSyncPage() {
					openSyncPage()
				} else {
					openAllDonePage()
				}
			},
			onErrorHandling: { error in
				self.displayError(error)
			},
			hideError: {
				self.verifyPassView?.hideError()
			},
			selectedPasscode: selectedPasscode,
			selectedAccounts: selectedAccounts
		)
	}

	private func displayError(_ error: PassVerifyError) {
		// display error
		switch error {
		case .dontMatch:
			verifyPassView?.passDotsView.showErrorState()
			verifyPassView?.showErrorWith(text: verifyPassVM.errorTitle)
		case .saveFailed:
			fatalError("Print Failed")
		case .unknown:
			fatalError("Uknown Error")
		case .emptyPasscode:
			fatalError("Passcode sent to verify is empty")
		}
	}

	private func openAllDonePage() {
		let allDoneVC = AllDoneViewController(
			selectedAccounts: selectedAccounts,
			mnemonics: mnemonics
		)
		navigationController?.pushViewController(allDoneVC, animated: true)
	}

	private func openSyncPage() {
		let syncPage = SyncWalletViewController(selectedAccounts: selectedAccounts!, mnemonics: mnemonics)
		navigationController?.pushViewController(syncPage, animated: true)
	}
}
