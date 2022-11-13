//
//  StepWrapper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import Foundation

extension PinoSteperView {
	// MARK: Property wrapper

	@propertyWrapper
	struct StepsRange {
		// MARK: Lifecycle

		init(wrappedValue: Int, maxStep: Int, minStep: Int = 1) {
			self.maxStep = maxStep
			self.minStep = minStep

			// Current step value must be greater than zero and less than the total number of steps
			var wrappedStep = min(wrappedValue, maxStep)
			wrappedStep = max(wrappedStep, minStep)
			self.currentStep = wrappedStep
		}

		// MARK: Internal

		var wrappedValue: Int {
			get {
				return currentStep
			}
			set {
				// Current step value must be greater than zero and less than the total number of steps
				var wrappedStep = min(newValue, maxStep)
				wrappedStep = max(wrappedStep, minStep)
				currentStep = wrappedStep
			}
		}

		// MARK: Private

		private var currentStep: Int
		private var maxStep: Int
		private var minStep: Int
	}
}
