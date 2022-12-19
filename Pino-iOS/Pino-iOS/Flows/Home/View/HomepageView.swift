//
//  HomepageView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import UIKit

class HomepageView: UIView {
	// MARK: - Private Properties

	private let assetsCollectionView = HomepageCollectionView()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension HomepageView {
	// MARK: - UI Methods

	private func setupView() {
		addSubview(assetsCollectionView)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground
	}

	private func setupContstraint() {
		assetsCollectionView.pin(
			.width(to: self),
			.allEdges
		)
	}
}
