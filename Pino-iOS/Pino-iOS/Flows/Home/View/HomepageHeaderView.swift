//
//  HomepageHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import UIKit

class HomepageHeaderView: UICollectionReusableView {
	public static let headerReuseID = "homepgaeHeader"

	public var titleLabel = UILabel()

	public var title: String! {
		didSet {
			addSubview(titleLabel)
			titleLabel.pin(.allEdges)
			titleLabel.text = title
		}
	}
}
