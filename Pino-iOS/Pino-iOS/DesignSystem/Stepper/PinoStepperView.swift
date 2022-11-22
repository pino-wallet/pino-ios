//
//  Steper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

public class PinoStepperView: UIView {
	// MARK: Private properties

	private var stepViews: [UIView] = []
	private var stepsCount: Int
	private var currentStep: Int {
		didSet {
			updateStep()
		}
	}

	// MARK: Initializers

	public init(stepsCount: Int, currentStep: Int) {
		self.currentStep = currentStep
		self.stepsCount = stepsCount
		super.init(frame: .zero)

		createStepsView()
	}

	public required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Private methods

	private func updateStep() {
		// Current step must be greater than zero and less than steps count
		if currentStep > stepsCount {
			currentStep = stepsCount
		}
		if currentStep < 1 {
			currentStep = 1
		}
		// Update the colors when the current step changes
		for (index, stepView) in stepViews.enumerated() {
			if index < currentStep {
				stepView.backgroundColor = .Pino.primary
			} else {
				stepView.backgroundColor = .Pino.gray4
			}
		}
	}

	private func isCurrentStepValid() -> Bool {
		stepViews.indices.contains(currentStep - 1)
	}

	private func createStepsView() {
		backgroundColor = .Pino.clear

		let steperStackView = UIStackView()
		steperStackView.axis = .horizontal
		steperStackView.spacing = 12
		addSubview(steperStackView)

		// Create UI view for each step
		for _ in 1 ... stepsCount {
			let stepView = UIView()
			steperStackView.addArrangedSubview(stepView)
			stepViews.append(stepView)
			stepView.pin(.fixedHeight(2), .fixedWidth(40))
		}
		steperStackView.pin(.centerX, .centerY)
		updateStep()
	}
}
