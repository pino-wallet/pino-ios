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
		setupView()
		setSteperView(stepsCount: 3, curreuntStep: 3)
	}

	// MARK: Private Methods

	private func setupView() {
		// Custom view should be created
		configVerifyPassVM()
		createPassView = ManagePasscodeView(managePassVM: verifyPassVM)
		view = createPassView
		createPassView?.passDotsView.becomeFirstResponder()
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
				self.createPassView?.passDotsView.showErrorState()
				self.createPassView?.showErrorWith(text: "Incorrect, try again!")
			case .saveFailed:
				fatalError("Print Failed")
			case .unknown:
				fatalError("Uknown Error")
			case .emptyPasscode:
				fatalError("Passcode sent to verify is empty")
			}
		}, hideError: {
			self.createPassView?.hideError()
		}, selectedPasscode: selectedPasscode)
	}
}
