//
//  Steper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

public class PinoSteperView: UIView {
	// MARK: Lifecycle

	// MARK: Initializers

	public init(stepsCount: Int, currentStep: Int) {
		@StepsRange(wrappedValue: currentStep, maxStep: stepsCount)
		var wrappedStep
		self.currentStep = wrappedStep
		self.stepsCount = stepsCount
		super.init(frame: .zero)

		createStepsView()
	}

	public required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Public

	// MARK: Public properties

	public var stepsCount: Int

	// MARK: Internal

	// MARK: Private methods

	func updateStep() {
		// Update the colors when the current step changes
		stepViews.forEach { $0.backgroundColor = .Pino.gray4 }
		stepViews[currentStep - 1].backgroundColor = .Pino.primary
	}

	func createStepsView() {
		backgroundColor = .Pino.clear

		let steperStackView = UIStackView()
		steperStackView.axis = .horizontal
		steperStackView.spacing = 12
		addSubview(steperStackView)

		// Create UI view for each step
		for _ in 1 ... stepsCount {
			let stepView = UIView()
			stepView.backgroundColor = .Pino.gray4

			steperStackView.addArrangedSubview(stepView)
			stepViews.append(stepView)

			stepView.pin(.fixedHeight(2), .fixedWidth(40))
		}

		stepViews[currentStep - 1].backgroundColor = .Pino.primary

		steperStackView.pin(.centerX, .centerY)
	}

	// MARK: public methods

	func setCurrentStep(_ currentStep: Int) {
		@StepsRange(wrappedValue: currentStep, maxStep: stepsCount)
		var wrappedStep
		self.currentStep = wrappedStep
	}

	// MARK: Private

	// MARK: Private properties

	private var stepViews: [UIView] = []

	private var currentStep: Int {
		didSet {
			updateStep()
		}
	}
}
