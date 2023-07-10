//
//  ActivityViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class ActivityViewController: UIViewController {
	// MARK: - Private Properties

	private let activityVM = ActivityViewModel()
	private var activityColectionView: ActivityCollectionView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		activityVM.refreshUserActivities()
	}

	override func viewWillDisappear(_ animated: Bool) {
		activityVM.destroyTimer()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(activityVM.pageTitle)
	}

	private func setupView() {
		activityColectionView = ActivityCollectionView(activityVM: activityVM)
		view = activityColectionView
	}
}
