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
    public var createPassVM: CreatePassVM!
    
	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView()
	}

    override func viewDidAppear(_ animated: Bool) {
        // User might enter a passcode, Head to verify page, but then navigate back to
        // Create Pass again. In this scenario we reset the already defined passcode
        createPassVM.resetPassword()
    }

	// MARK: Private Methods

	private func stupView() {
		// Custom view should be created

        createPassVM = CreatePassVM(finishPassCreation: {
            // Passcode was chose -> Show verify passcode page
            let verifyPassVC = VerifyPasscodeViewController()
            self.navigationController?.pushViewController(verifyPassVC, animated: true)
        })
		createPassView = ManagePasscodeView(managePassVM: createPassVM)
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
