//
//  StepWrapper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import Foundation

extension PinoStepperView {
	// MARK: Property wrapper

	@propertyWrapper
	struct StepsRange {
		// MARK: Private properties

		private var currentStep: Int
		private var maxStep: Int
		private var minStep: Int

		// MARK: public properties

		public var wrappedValue: Int {
			get {
				currentStep
			}
			set {
				// Current step value must be greater than zero and less than the total number of steps
				var wrappedStep = min(newValue, maxStep)
				wrappedStep = max(wrappedStep, minStep)
				currentStep = wrappedStep
			}
		}

		// MARK: Initializers

		init(wrappedValue: Int, maxStep: Int, minStep: Int = 1) {
			self.maxStep = maxStep
			self.minStep = minStep

			// Current step value must be greater than zero and less than the total number of steps
			var wrappedStep = min(wrappedValue, maxStep)
			wrappedStep = max(wrappedStep, minStep)
			self.currentStep = wrappedStep
		}
	}
}
