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

	// MARK: Public Properties

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		verifyPassVM.error.addObserver(self) { error in
			// display error
			switch error {
			case .notTheSame:
				self.createPassView?.passDotsView.showErrorState()
			case .saveFailed:
				fatalError("Print Failed")
			case .none:
				fatalError("Uknown Error")
			}
		}
		createPassView?.passDotsView.becomeFirstResponder()
	}

	override func loadView() {
		stupView()
		setSteperView()
	}

	// MARK: Private Methods

	private func stupView() {
		// Custom view should be created
		verifyPassVM = VerifyPassVM {
			// Passcode waa verified -> Show all done page
		}
		createPassView = ManagePasscodeView(managePassVM: verifyPassVM)
		view = createPassView
		view.backgroundColor = .Pino.secondaryBackground
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let steperView = PinoStepperView(stepsCount: 3, currentStep: 3)
		navigationItem.titleView = steperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}
}
