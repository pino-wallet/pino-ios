//
//  TutorialViewViewModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Combine
import Foundation

class TutorialContainerViewModel {
	// MARK: - Private Properties

	private var tutorialType: TutorialType

	@Published
	public var currentIndex = 0
	@Published
	public var isPaused: Bool?
	public var watchedTutorial: () -> Void

	// MARK: - Public Properties

	public var tutorials: [TutorialModel] {
		getTutorialsOf(type: tutorialType)
	}

	// MARK: - Initializer

	init(tutorialType: TutorialType, completion: @escaping () -> Void) {
		self.tutorialType = tutorialType
		self.watchedTutorial = completion
	}

	// MARK: - Public Methods

	public func nextTutorial() {
		currentIndex += 1
	}

	public func prevTutorial() {
		if currentIndex == 0 {
			currentIndex = 0
		} else {
			currentIndex -= 1
		}
	}

	public func getTutorialsOf(type: TutorialType) -> [TutorialModel] {
		TutorialModel.tutorials.filter { $0.type == type }
	}
}
