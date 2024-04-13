//
//  PinoProgressView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/8/24.
//

import Foundation
import UIKit

class PinoProgressView: UIView {
	// MARK: - Closures

	public var completion: () -> Void = {}

	// MARK: - Private Properties

	private let progressContainerView = UIView()
	private let progressBarView = UIView()
	private let progressBarVM: PinoProgressBarViewModel
	private var progressFullConstraint: NSLayoutConstraint!
	private var currentProgressViewWidth: CGFloat = 0
	private var containerProgressBarWidth: CGFloat = 0

	// MARK: - Initializers

	init(progressBarVM: PinoProgressBarViewModel) {
		self.progressBarVM = progressBarVM

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		progressFullConstraint = NSLayoutConstraint(
			item: progressBarView,
			attribute: .trailing,
			relatedBy: .equal,
			toItem: progressContainerView,
			attribute: .trailing,
			multiplier: 1,
			constant: 0
		)

		progressContainerView.addSubview(progressBarView)

		addSubview(progressContainerView)
	}

	private func setupStyles() {
		progressContainerView.layer.cornerRadius = 2
		progressContainerView.backgroundColor = progressBarVM.customContainerColor ?? .Pino.gray4

		progressBarView.layer.cornerRadius = 2
		progressBarView.backgroundColor = progressBarVM.customFillColor ?? .Pino.primary
	}

	private func setupConstraints() {
		progressContainerView.pin(.allEdges(padding: 0), .fixedHeight(4))
		progressBarView.pin(.leading(padding: 0), .verticalEdges(padding: 0))
	}

	private func animateProgress(duration: Double) {
		layoutIfNeeded()
		containerProgressBarWidth = progressContainerView.frame.width
		UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) { [weak self] in
			self?.progressFullConstraint.constant = 0
			self?.progressFullConstraint.isActive = true
			self?.layoutIfNeeded()
		} completion: { _ in
			self.completion()
		}
	}

	// MARK: - Public Methods

	public func start() {
		animateProgress(duration: progressBarVM.progressDuration)
	}

	public func startFrom(currentPercentage: Double) {
		guard currentPercentage < 100 else {
			return
		}
		layoutIfNeeded()
		containerProgressBarWidth = progressContainerView.frame.width
		let onePercentOfViewWidth = containerProgressBarWidth / 100
		let onePercentOfProgressTime = progressBarVM.progressDuration / 100
		let remainingProgressTime = currentPercentage * onePercentOfProgressTime
		progressFullConstraint.constant = -(onePercentOfViewWidth * currentPercentage)
		progressFullConstraint.isActive = true
		animateProgress(duration: remainingProgressTime)
	}

	public func pause() {
		let presentView = progressBarView.layer.presentation()
		currentProgressViewWidth = presentView!.frame.width
		progressBarView.layer.removeAllAnimations()
		progressFullConstraint.constant = -(containerProgressBarWidth - currentProgressViewWidth)
	}

	public func resume() {
		let onePercentOfViewWidth = containerProgressBarWidth / 100
		let currentPercentOfProgress = currentProgressViewWidth / onePercentOfViewWidth
		let onePercentOfProgressTime = progressBarVM.progressDuration / 100
		let remainingProgressTime = (100 - currentPercentOfProgress) * onePercentOfProgressTime
		animateProgress(duration: remainingProgressTime)
	}

	public func restart() {
		progressBarView.layer.removeAllAnimations()
		progressFullConstraint.constant = -containerProgressBarWidth
		animateProgress(duration: progressBarVM.progressDuration)
	}

	public func reset() {
		progressBarView.layer.removeAllAnimations()
		progressFullConstraint.constant = -containerProgressBarWidth
	}

	public func fill() {
		progressBarView.layer.removeAllAnimations()
		progressFullConstraint.constant = containerProgressBarWidth
		animateProgress(duration: 0)
	}
}
