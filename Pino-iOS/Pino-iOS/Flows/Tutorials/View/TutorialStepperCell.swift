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

	private var stepProgressView =
		PinoProgressView(progressBarVM: .init(progressDuration: 5, customContainerColor: .Pino.secondaryBackground))
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public static let cellReuseID = "tutStepperCell"

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(stepProgressView)
	}

	private func setupBinding() {}

	private func setupStyle() {}

	private func setupConstraint() {
		stepProgressView.pin(
			.allEdges,
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

	public func startProgress(completed: @escaping () -> Void) {
		stepProgressView.start()
		stepProgressView.completion = {
			completed()
		}
	}

	public func resetProgress() {
		stepProgressView.completion = {}
		stepProgressView.reset()
	}

	public func fillProgress() {
		stepProgressView.completion = {}
		stepProgressView.fill()
	}

	public func pauseProgress() {
		stepProgressView.completion = {}
		stepProgressView.pause()
	}

	public func progressFilling(completed: @escaping () -> Void) {
		stepProgressView.resume()
		stepProgressView.completion = {
			completed()
		}
	}
}
