//
//  CreatePasscodeViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class CreatePasscodeViewController: UIViewController {
	// MARK: Public Properties

	public var createPassView: ManagePasscodeView?
	public var createPassVM: SelectPassVM!
	public var pageSteps: Int!

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: pageSteps, curreuntStep: pageSteps)
		setupNavigationBackButton()
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

		createPassVM = SelectPassVM(finishPassCreation: { passcode in
			// Passcode was chose -> Show verify passcode page
			let verifyPassVC = VerifyPasscodeViewController()
			verifyPassVC.selectedPasscode = passcode
			self.navigationController?.pushViewController(verifyPassVC, animated: true)
		}, onErrorHandling: { error in
			switch error {
			case .emptySelectedPasscode:
				fatalError("Selected passcode by user is empty")
			}
		})
	}

	private func stupView() {
		configCreatePassVM()
		createPassView = ManagePasscodeView(managePassVM: createPassVM)
		view = createPassView
	}
}
