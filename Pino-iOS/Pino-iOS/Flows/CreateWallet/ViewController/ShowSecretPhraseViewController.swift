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
        let secretPhraseView = ShowSecretPhraseView(secretPhraseVM.secretPhrase)
        secretPhraseView.shareSecretPhrase = {
            self.shareSecretPhrase()
        }
        view = secretPhraseView
        setSteperView()
	}
    
    // MARK: Private Methods
    
    private func setSteperView() {
        // show steper view in navigation bar
        let steperView = PinoSteperView(stepsCount: 3, currentStep: 1)
        navigationItem.titleView = steperView
        navigationController?.navigationBar.backgroundColor = .Pino.background
    }
    
    @objc
    private func shareSecretPhrase() {
        let userWords = secretPhraseVM.secretPhrase.map { $0.title }
        let shareText = "Secret Phrase: \(userWords.joined(separator: " "))"
        let shareActivity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(shareActivity, animated: true) {
            
        }
    }
}
