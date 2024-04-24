//
//  NotificationViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationSettingsViewController: UIViewController {
	// MARK: - Private Properties

	private let notificationsVM = NotificationSettingsViewModel()
	private var notificationsCollectionView: NotificationSettingsCollectionView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
		setupNotifications()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		notificationsCollectionView.reloadData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			HapticManager().run(type: .lightImpact)
		}
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(notificationsVM.pageTitle)
	}

	private func setupView() {
		notificationsCollectionView = NotificationSettingsCollectionView(
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

	private func setupNotifications() {
		let notificationsCenter = NotificationCenter.default
		notificationsCenter.addObserver(
			self,
			selector: #selector(didBecomeActive),
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}

	private func removeNotifications() {
		NotificationCenter.default.removeObserver(
			self,
			name: UIApplication.didBecomeActiveNotification,
			object: nil
		)
	}

	@objc
	private func didBecomeActive() {
		notificationsCollectionView.reloadData()
	}
}
