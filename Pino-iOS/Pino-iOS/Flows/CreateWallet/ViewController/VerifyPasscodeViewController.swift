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
		setNavigationBackButton()
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
			}
		}, selectedPasscode: selectedPasscode)
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let steperView = PinoStepperView(stepsCount: 3, currentStep: 3)
		navigationItem.titleView = steperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}

	private func setNavigationBackButton() {
		let backImage = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem(
			image: backImage,
			style: .plain,
			target: self,
			action: #selector(backToPreviousPage)
		)
		backButton.tintColor = .Pino.label
		navigationItem.setLeftBarButton(backButton, animated: true)
	}

	@objc
	private func backToPreviousPage() {
		navigationController?.popViewController(animated: true)
	}
}
