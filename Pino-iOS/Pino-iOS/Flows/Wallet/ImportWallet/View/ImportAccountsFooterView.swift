//
//  ImportAccountsFooterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsFooterView: UICollectionReusableView {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let findAccountButton = UIButton()
	private let loadingView = UIActivityIndicatorView()

	// MARK: - Public Properties

	public static let footerReuseID = "importAccountsFooter"
	public var title: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentView)
		contentView.addSubview(findAccountButton)
		contentView.addSubview(loadingView)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		findAccountButton.setTitle(title, for: .normal)
		findAccountButton.setTitleColor(.Pino.primary, for: .normal)
		findAccountButton.titleLabel?.font = .PinoStyle.semiboldCallout
	}

	private func setupConstraint() {
		contentView.pin(
			.top(padding: 32),
			.centerX
		)
		findAccountButton.pin(
			.centerY,
			.horizontalEdges
		)
		loadingView.pin(
			.centerX,
			.verticalEdges
		)
	}
}
