//
//  ApprovingContractLoadingView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/24/23.
//

import Combine
import Foundation
import UIKit

class ApprovingLoadingView: UIView {
	// MARK: Private Properties

	private let approvngContractLoadingVM: ApprovingLoadingViewModel!
	private let loading = PinoLoading(size: 48)
	private let loadingTextLabel = PinoLabel(style: .description, text: "")
	private let loadingStackView = UIStackView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(approvingLoadingVM: ApprovingLoadingViewModel) {
		self.approvngContractLoadingVM = approvingLoadingVM

		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .Pino.background

		loadingStackView.addSubview(loading)

		loadingStackView.addArrangedSubview(loading)
		loadingStackView.addArrangedSubview(loadingTextLabel)

		addSubview(loadingStackView)
	}

	private func setupStyle() {
		loadingTextLabel.font = .PinoStyle.mediumTitle2
		loadingTextLabel.text = "Approving..."
		loadingTextLabel.numberOfLines = 0
		loadingTextLabel.textAlignment = .center

		loading.style = .large
		loading.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

		loadingStackView.axis = .vertical
		loadingStackView.spacing = 24
		loadingStackView.alignment = .center
	}

	private func setupContstraint() {
		loadingStackView.pin(
			.centerX,
			.centerY
		)
	}

	private func setupBindings() {}
}
