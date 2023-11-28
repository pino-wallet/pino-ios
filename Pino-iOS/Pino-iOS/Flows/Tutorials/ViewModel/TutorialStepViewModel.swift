//
//  TutorialStepViewModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Foundation
import Combine

struct TutorialStepViewModel {
    
    // MARK: - Public properties
    public var isPause = true

    // MARK: - Private properties
    private(set) var progressValue = CurrentValueSubject<(value: Float, animated: Bool), Never>((Float(0),true))
    
    // MARK: - Public Methods
    public func setProgress(value: Float, animated: Bool) {
        progressValue.send((value,animated))
    }
    
}
