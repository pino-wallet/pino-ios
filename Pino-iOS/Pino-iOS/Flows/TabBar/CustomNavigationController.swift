//
//  CustomNavigationController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/28/23.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNeedsStatusBarAppearanceUpdate()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		.darkContent
	}
}
