//
//  UITabBarController+Extension.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/7/23.
//

import UIKit

extension UITabBarController {
	public func addCustomTabBarBadgeFor(index: Int, customView: UIView) {
		let currentTabBarSubview = tabBar.subviews[index]
		currentTabBarSubview.addSubview(customView)
		customView.layer.zPosition = 2
		if let imageView = currentTabBarSubview.subviews.compactMap({ $0 as? UIImageView }).first {
			imageView.layer.zPosition = 1
		}
	}
}
