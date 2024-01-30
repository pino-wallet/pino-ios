//
//  CreatePasscodeViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class CreatePasscodeViewController: UIViewController {
	// MARK: - Private Properties

	private var selectedAccounts: [ActiveAccountViewModel]?
	private var mnemonics: String

	// MARK: Public Properties

	public var createPassView: ManagePasscodeView?
	public var createPassVM: SelectPassViewModel!
	public var pageSteps: Int!
	public var currentStep: Int!

	// MARK: - initializers

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

	override func loadView() {
		setupView()
		setSteperView(stepsCount: pageSteps, curreuntStep: currentStep)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// User might enter a passcode, Head to verify page, but then navigate back to
		// Create Pass again. In this scenario we reset the already defined passcode
		createPassView?.passDotsView.resetDotsView()
	}

	override func viewDidAppear(_ animated: Bool) {
		createPassView?.passDotsView.becomeFirstResponder()
	}

	// MARK: Private Methods

	private func configCreatePassVM() {
		// Custom view should be created
		createPassVM = SelectPassViewModel(finishPassCreation: { [self] passcode in
			// Passcode was chose -> Show verify passcode page
			let verifyPassVC = VerifyPasscodeViewController(
				selectedAccounts: selectedAccounts,
				mnemonics: mnemonics
			)
			verifyPassVC.selectedPasscode = passcode
			verifyPassVC.pageSteps = pageSteps
			verifyPassVC.currentStep = currentStep + 1
			navigationController?.pushViewController(verifyPassVC, animated: true)
		}, onErrorHandling: { error in
			switch error {
			case .emptySelectedPasscode:
				fatalError("Selected passcode by user is empty")
			}
		})
	}

	private func setupView() {
		configCreatePassVM()
		createPassView = ManagePasscodeView(managePassVM: createPassVM)
		view = createPassView
	}
}
