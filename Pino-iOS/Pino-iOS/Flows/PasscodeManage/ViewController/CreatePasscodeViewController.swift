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

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView()
		setNavigationBackButton()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// User might enter a passcode, Head to verify page, but then navigate back to
		// Create Pass again. In this scenario we reset the already defined passcode
		createPassView?.passDotsView.resetDotsView()
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
