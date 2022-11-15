//
//  CreatePasscodeViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class CreatePasscodeViewController: UIViewController {
        
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
        view.backgroundColor = .Pino.secondaryBackground
    }
    
    private func setSteperView() {
        // show steper view in navigation bar
        let steperView = PinoStepperView(stepsCount: 3, currentStep: 3)
        navigationItem.titleView = steperView
        navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
    }
}
