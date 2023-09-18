//
//  InvestAssetImageView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation
import UIKit

class InvestAssetImageView: UIView {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let assetImageView = UIImageView()
	private let protocolImageView = UIImageView()
	private let unverifiedAssetImage = "unverified_asset"

	// MARK: - Public Properties

	public var assetImage: URL? {
		didSet {
			setupAssetImage(assetImage)
		}
	}

	public var protocolImage: String? {
		didSet {
			setupProtocolImage(protocolImage)
		}
	}

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentView)
		contentView.addSubview(assetImageView)
		contentView.addSubview(protocolImageView)
	}

	private func setupConstraint() {
		contentView.pin(
			.allEdges
		)
		assetImageView.pin(
			.allEdges
		)
		protocolImageView.pin(
			.trailing,
			.bottom
		)

		NSLayoutConstraint.activate([
			protocolImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.42),
			protocolImageView.widthAnchor.constraint(equalTo: protocolImageView.heightAnchor),
		])
	}

	private func setupAssetImage(_ assetImage: URL?) {
		if let assetImage {
			assetImageView.kf.indicatorType = .activity
			assetImageView.kf.setImage(with: assetImage)
		} else {
			assetImageView.image = UIImage(named: unverifiedAssetImage)
		}
	}

	private func setupProtocolImage(_ protocolImage: String?) {
		guard let protocolImage else { return }
		protocolImageView.image = UIImage(named: protocolImage)
	}
}
