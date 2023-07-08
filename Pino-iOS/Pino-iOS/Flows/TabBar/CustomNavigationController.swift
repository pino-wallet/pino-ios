//
//  CustomNavigationController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/28/23.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
	// MARK: - Private Properties

	private let statusBarStyle: UIStatusBarStyle

	// MARK: - Initializers

	init(rootViewController: UIViewController, statusBarStyle: UIStatusBarStyle = .darkContent) {
		self.statusBarStyle = statusBarStyle
		super.init(rootViewController: rootViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNeedsStatusBarAppearanceUpdate()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		statusBarStyle
	}
}
