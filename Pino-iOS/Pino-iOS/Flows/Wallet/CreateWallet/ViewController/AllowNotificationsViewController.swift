//
//  AllowNotificationsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/7/23.
//

import UIKit

class AllowNotificationsViewController: UIViewController {
	// MARK: - Private Properties

	private let allowNotificationsVM = AllowNotificationsViewModel()
	private var allowNotificationsView: AllowNotificationsView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			allowNotificationsView.setupGradientStyle()
			allowNotificationsView.animateSmapleNotificationsCard()
		}
	}

	override func loadView() {
		setupView()
		setupClearColorNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		allowNotificationsView = AllowNotificationsView(allowNotificationsVM: allowNotificationsVM)
		view = allowNotificationsView
	}
}
