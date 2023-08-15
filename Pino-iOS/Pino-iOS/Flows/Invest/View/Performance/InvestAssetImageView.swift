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

	private let assetImage: URL?
	private let protocolImage: String?
	private let unverifiedAssetImage = "unverified_asset"

	// MARK: - Initializers

	init(assetImage: URL?, protocolImage: String?) {
		self.assetImage = assetImage
		self.protocolImage = protocolImage
		super.init(frame: .zero)
		setupView()
		setupStyle()
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

	private func setupStyle() {
		if let assetImage {
			assetImageView.kf.indicatorType = .activity
			assetImageView.kf.setImage(with: assetImage)
		} else {
			assetImageView.image = UIImage(named: unverifiedAssetImage)
		}

		if let protocolImage {
			protocolImageView.image = UIImage(named: protocolImage)
		}
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
			protocolImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
			protocolImageView.widthAnchor.constraint(equalTo: protocolImageView.heightAnchor),
		])
	}
}
