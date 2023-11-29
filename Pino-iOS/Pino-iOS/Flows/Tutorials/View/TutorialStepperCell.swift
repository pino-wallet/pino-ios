//
//  TutorialStepperCell.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Combine
import UIKit

class TutorialStepperCell: UICollectionViewCell {
	// MARK: Private Properties

	private let stepProgressView = UIProgressView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public static let cellReuseID = "tutStepperCell"
	public var tutStepperCellVM: TutorialStepViewModel!

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(stepProgressView)
	}

	private func setupBinding() {
		tutStepperCellVM.progressValue.sink { progValue in
			self.stepProgressView.setProgress(progValue.value, animated: progValue.animated)
		}.store(in: &cancellables)
	}

	private func setupStyle() {
		stepProgressView.progressViewStyle = .bar
		stepProgressView.trackTintColor = UIColor.Pino.white
		stepProgressView.progressTintColor = UIColor.Pino.primary
		stepProgressView.layer.cornerRadius = 2
		stepProgressView.setProgress(
			tutStepperCellVM.progressValue.value.value,
			animated: tutStepperCellVM.progressValue.value.animated
		)
	}

	private func setupConstraint() {
		stepProgressView.pin(
			.centerX,
			.centerY,
			.horizontalEdges(padding: 0),
			.top(padding: 0),
			.bottom(padding: 0),
			.fixedHeight(2)
		)
	}

	// MARK: Public Methods

	public func configCell() {
		setupView()
		setupStyle()
		setupConstraint()
		setupBinding()
	}

	public func startProgressFrom(value: Int, completed: @escaping () -> Void) {
		stepProgressView.progress = 0
		tutStepperCellVM.progress.completedUnitCount = 0

		tutStepperCellVM.timer = Timer
			.scheduledTimer(withTimeInterval: tutStepperCellVM.timeInterval, repeats: true) { [self] timer in

				guard tutStepperCellVM.progress.isFinished == false else {
					tutStepperCellVM.timer?.invalidate()
					completed()
					return
				}

				tutStepperCellVM.progress.completedUnitCount += 1
				let progressFloat = Float(tutStepperCellVM.progress.fractionCompleted)
				stepProgressView.setProgress(progressFloat, animated: true)

				tutStepperCellVM.setProgress(value: progressFloat, animated: true)
			}
	}

	public func pauseProgress() {
		tutStepperCellVM.isPause = true
	}
}
