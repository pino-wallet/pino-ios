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

	public var findAccountDidTap: (() -> Void)!

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentView)
		contentView.addSubview(findAccountButton)
		contentView.addSubview(loadingView)

		findAccountButton.addAction(UIAction(handler: { _ in
			self.findAccountDidTap()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		findAccountButton.setTitle(title, for: .normal)
		findAccountButton.setTitleColor(.Pino.primary, for: .normal)
		findAccountButton.titleLabel?.font = .PinoStyle.semiboldCallout
		loadingView.color = .Pino.primary
	}

	private func setupConstraint() {
		contentView.pin(
			.top(padding: 12),
			.centerX
		)
		findAccountButton.pin(
			.centerY,
			.horizontalEdges
		)
		loadingView.pin(
			.fixedWidth(32),
			.fixedHeight(32),
			.centerX,
			.verticalEdges
		)
	}

	// MARK: - Public Methods

	public func startLoading() {
		loadingView.startAnimating()
		findAccountButton.isHidden = true
	}

	public func stopLoading() {
		loadingView.stopAnimating()
		findAccountButton.isHidden = false
	}
}
