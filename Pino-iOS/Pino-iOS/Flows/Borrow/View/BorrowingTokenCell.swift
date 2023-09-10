//
//  BorrowingTokenCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/22/23.
//

import UIKit

class BorrowingTokenCell: UICollectionViewCell {
	// MARK: - Private Properties

	private let containerView = UIView()
	private var tokenImageView = UIImageView()
	private var circleLayer = CAShapeLayer()
	private var progressLayer = CAShapeLayer()
	private var startPoint = CGFloat(-Double.pi / 2)
	private var endPoint = CGFloat(3 * Double.pi / 2)

	// MARK: - Public Properties

	public var borrowingTokenVM: BorrowingTokenCellViewModel? {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
			createCircularPath()
			animatePercentageProgressbar()
			setupSkeletonViews()
			if borrowingTokenVM != nil {
				hideSkeletonView()
			} else {
				showSkeletonView()
			}
		}
	}

	public var progressBarColor = UIColor.Pino.primary {
		didSet {
			progressLayer.strokeColor = progressBarColor.cgColor
		}
	}

	public static let cellReuseId = "borrowingTokenCell"

	// MARK: - Private Methods

	private func setupView() {
		containerView.addSubview(tokenImageView)

		addSubview(containerView)
	}

	private func setupStyles() {
		guard let tokenImage = borrowingTokenVM?.tokenImage else {
			return
		}
		tokenImageView.image = UIImage(named: tokenImage)
	}

	private func setupConstraints() {
		containerView.pin(.allEdges(padding: 0))
		tokenImageView.pin(.fixedHeight(25.3), .fixedWidth(25.3), .centerX(), .centerY())
	}

	private func createCircularPath() {
		let circularPath = UIBezierPath(
			arcCenter: CGPoint(x: 32 / 2, y: 32 / 2),
			radius: 14.7,
			startAngle: startPoint,
			endAngle: endPoint,
			clockwise: true
		)

		circleLayer.path = circularPath.cgPath
		circleLayer.fillColor = nil
		circleLayer.lineCap = .round
		circleLayer.lineWidth = 2.5
		circleLayer.strokeColor = UIColor.Pino.gray5.cgColor
		circleLayer.strokeEnd = 1

		containerView.layer.addSublayer(circleLayer)

		progressLayer.path = circularPath.cgPath
		progressLayer.fillColor = nil
		progressLayer.lineCap = .round
		progressLayer.lineWidth = 2.5
		progressLayer.strokeColor = UIColor.Pino.primary.cgColor
		progressLayer.strokeEnd = 0

		containerView.layer.addSublayer(progressLayer)
	}

	private func animatePercentageProgressbar() {
		let newTotalSharedBorrowingDividedPercentage = borrowingTokenVM?.totalSharedBorrowingDividedPercentage
		let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
		if let borrowingPercentage = borrowingTokenVM?.prevTotalSharedBorrowingDividedPercentage,
		   !borrowingPercentage.isZero {
			progressAnimation.fromValue = borrowingTokenVM?.prevTotalSharedBorrowingDividedPercentage
		}
		progressAnimation.duration = 0.5
		progressAnimation.toValue = newTotalSharedBorrowingDividedPercentage
		progressAnimation.fillMode = .forwards
		progressAnimation.isRemovedOnCompletion = false

		progressLayer.add(progressAnimation, forKey: "progressAnimationKey")
	}

	private func setupSkeletonViews() {
		containerView.isSkeletonable = true
	}
}
