//
//  ClearNavigationBar.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/15/23.
//

import UIKit

class ClearNavigationBar: UINavigationBar {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let leftSectionView = UIView()
	private let rightSectionView = UIView()

	// MARK: -  Initializers

	init() {
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func setRightSectionView(view: UIView) {
		rightSectionView.addSubview(view)

		view.pin(.allEdges(padding: 0))
	}

	public func setLeftSectionView(view: UIView) {
		leftSectionView.addSubview(view)

		view.pin(.allEdges(padding: 0))
	}

	// MARK: - Private Methods

	private func setupView() {
		mainStackView.addArrangedSubview(leftSectionView)
		mainStackView.addArrangedSubview(rightSectionView)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .clear

		mainStackView.axis = .horizontal
		mainStackView.distribution = .fillEqually
	}

	private func setupConstraints() {
		pin(.fixedHeight(58), .horizontalEdges(to: layoutMarginsGuide, padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 16), .verticalEdges(padding: 0))
	}
}
