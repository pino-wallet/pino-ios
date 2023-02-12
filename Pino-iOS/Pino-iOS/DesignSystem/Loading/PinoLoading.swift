//
//  PinoLoading.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/12/23.
//

import UIKit

class PinoLoading: UIImageView {
	// MARK: - Public Properties

	public var size: Int {
		didSet {
			print("amir")
			setupConstraints()
		}
	}

	// MARK: - Ptivate Properties

	private var timer: Timer?

	init(size: Int) {
		self.size = size
		super.init(frame: .zero)
		setupView()
		setupConstraints()
		startAnimatingLoading()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func startAnimatingLoading() {
		if timer == nil {
			timer = Timer.scheduledTimer(
				timeInterval: 0.0,
				target: self,
				selector: #selector(animateLoading),
				userInfo: nil,
				repeats: false
			)
		}
	}

	private func setupView() {
		image = UIImage(named: "spinner")
	}

	private func setupConstraints() {
		pin(.fixedHeight(CGFloat(size)), .fixedWidth(CGFloat(size)))
	}

	@objc
	private func animateLoading() {
		UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: { [weak self] in
			self?.transform = self?.transform.rotated(by: CGFloat(Double.pi)) ?? UIImageView().transform
		}, completion: { [weak self] finished in
			if self?.timer != nil {
				self?.timer = Timer.scheduledTimer(
					timeInterval: 0.0,
					target: self ?? UIImageView(),
					selector: #selector(self?.animateLoading),
					userInfo: nil,
					repeats: false
				)
			}
		})
	}
}
