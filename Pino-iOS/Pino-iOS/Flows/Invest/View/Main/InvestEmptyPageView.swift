//
//  InvestEmptyPageView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/5/23.
//

import UIKit

class InvestEmptyPageView: UIView {
	// MARK: Private Properties

	private let emptyStateView = EmptyStateCardView(properties: .invest)
	private var startInvestingDidTap: () -> Void

	// MARK: Initializers

	init(startInvestingDidTap: @escaping () -> Void) {
		self.startInvestingDidTap = startInvestingDidTap
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(emptyStateView)
		emptyStateView.onActionButtonTap = startInvestingDidTap
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
	}

	private func setupContstraint() {
		emptyStateView.pin(
			.top(to: layoutMarginsGuide, padding: 26),
			.horizontalEdges(padding: 16)
		)
	}
}
