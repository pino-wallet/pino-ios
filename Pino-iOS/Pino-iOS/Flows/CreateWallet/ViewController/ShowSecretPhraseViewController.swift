//
//  ShowSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		view = ShowSecretPhraseView()
		navigationItem.titleView = PinoSteperView(stepsCount: 3, currentStep: 1)
		navigationController?.navigationBar.backgroundColor = .Pino.background
	}
}
