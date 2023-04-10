//
//  NotificationViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationsViewController: UIViewController {
	// MARK: - Private Properties

	private let notificationsVM = NotificationsViewModel()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(notificationsVM.pageTitle)
	}

	private func setupView() {
		let notificationsCollectionView = NotificationsCollectionView(
			notificationsVM: notificationsVM,
			openTooltipAlert: { [weak self] tooltipTitle, tooltipText in
				self?.openTooltipAlertAction(tooltipTitle: tooltipTitle, tooltipText: tooltipText)
			}
		)
		view = notificationsCollectionView
	}

	private func openTooltipAlertAction(tooltipTitle: String, tooltipText: String) {
		let tooltipActionSheet = InfoActionSheet(title: tooltipTitle, description: tooltipText)
		present(tooltipActionSheet, animated: true)
	}
}
