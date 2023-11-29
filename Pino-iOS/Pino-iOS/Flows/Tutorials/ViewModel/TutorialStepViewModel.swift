//
//  TutorialStepViewModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Combine
import Foundation

struct TutorialStepViewModel {
	// MARK: - Public properties

	public var isPause = true
	public var timer: Timer?
	public let timeInterval = 0.01 // Time interval for the timer
	public var progress = Progress(totalUnitCount: TutorialStepViewModel.totalUnitCount)
	public var progressFloat: Float {
		Float(progress.fractionCompleted)
	}

	// MARK: - Private properties

	private(set) var progressValue = CurrentValueSubject<(value: Float, animated: Bool), Never>((Float(0), true))
	private static let totalUnitCount: Int64 = 200

	// MARK: - Public Methods

	public func setProgress(value: Float, animated: Bool) {
		progressValue.send((progressFloat, animated))
	}

	public func resetProgress() {
		progress.completedUnitCount = 0
		timer?.invalidate()
		setProgress(value: Float(0), animated: false)
	}

	public func fillProgress() {
		progress.completedUnitCount = TutorialStepViewModel.totalUnitCount
		timer?.invalidate()
		setProgress(value: Float(100), animated: false)
	}
}
