//
//  VerifyPasscodeViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/20/22.
//

import UIKit

class VerifyPasscodeViewController: UIViewController {
	// MARK: Private Properties

	public var verifyPassView: ManagePasscodeView?
	public var verifyPassVM: VerifyPassVM!
	public var selectedPasscode = ""

	// MARK: Public Properties

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
		verifyPassVM = VerifyPassVM(finishPassCreation: {
			// Passcode waa verified -> Show all done page
			let allDoneVC = AllDoneViewController()
			self.navigationController?.pushViewController(allDoneVC, animated: true)
		}, onErrorHandling: { error in
			// display error
			switch error {
			case .dontMatch:
				self.verifyPassView?.passDotsView.showErrorState()
				self.verifyPassView?.showErrorWith(text: "Incorrect, try again!")
			case .saveFailed:
				fatalError("Print Failed")
			case .unknown:
				fatalError("Uknown Error")
			case .emptyPasscode:
				fatalError("Passcode sent to verify is empty")
			}
		}, hideError: {
			self.verifyPassView?.hideError()
		}, selectedPasscode: selectedPasscode)
	}
}
