//
//  ShowSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let secretPhraseVM = SecretPhraseViewModel()

    // MARK: View Overrides
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
        view = ShowSecretPhraseView(secretPhraseVM.secretPhrase)
        setSteperView()
	}
    
    // MARK: Private Methods
    
    private func setSteperView() {
        // show steper view in navigation bar
        let steperView = PinoSteperView(stepsCount: 3, currentStep: 1)
        navigationItem.titleView = steperView
        navigationController?.navigationBar.backgroundColor = .Pino.background
    }
}
