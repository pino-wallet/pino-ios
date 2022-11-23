//
//  VerifyPasscodeViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/20/22.
//

import UIKit

class VerifyPasscodeViewController: UIViewController {
	// MARK: Private Properties

	public var createPassView: ManagePasscodeView?
	public var verifyPassVM: VerifyPassVM!
	public var selectedPasscode = ""

	// MARK: Public Properties

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView()
	}

	// MARK: Private Methods

	private func stupView() {
		// Custom view should be created

		configVerifyPassVM()
		createPassView = ManagePasscodeView(managePassVM: verifyPassVM)
		view = createPassView
		view.backgroundColor = .Pino.secondaryBackground
		createPassView?.passDotsView.becomeFirstResponder()
	}

	func configVerifyPassVM() {
		verifyPassVM = VerifyPassVM(finishPassCreation: {
			// Passcode waa verified -> Show all done page
		}, selectedPasscode: selectedPasscode)

		verifyPassVM.onErrorHandling = { error in
			// display error
			switch error {
			case .notTheSame:
				self.createPassView?.passDotsView.showErrorState()
			case .saveFailed:
				fatalError("Print Failed")
			case .unknown:
				fatalError("Uknown Error")
			}
		}
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let steperView = PinoStepperView(stepsCount: 3, currentStep: 3)
		navigationItem.titleView = steperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}
}
