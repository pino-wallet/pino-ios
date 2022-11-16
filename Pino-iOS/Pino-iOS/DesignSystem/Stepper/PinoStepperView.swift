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
		// Current step value must be greater than zero and less than the total number of steps
		switch currentStep {
		case _ where currentStep > stepsCount:
			currentStep = stepsCount
		case _ where currentStep < 1:
			currentStep = 1
		default:
			break
		}
		// Update the colors when the current step changes
		stepViews.forEach { $0.backgroundColor = .Pino.gray4 }
		stepViews[currentStep - 1].backgroundColor = .Pino.primary
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
