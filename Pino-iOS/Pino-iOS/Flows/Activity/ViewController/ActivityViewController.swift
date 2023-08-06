//
//  ActivityViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import Combine
import UIKit

class ActivityViewController: UIViewController {
	// MARK: - Private Properties

	private let activityVM = ActivityViewModel()
	private var activityEmptyStateView: ActivityEmptyStateView!
	private var activityColectionView: ActivityCollectionView!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
		setupBindings()
	}

	override func viewWillAppear(_ animated: Bool) {
		activityVM.getUserActivitiesFromVC()
	}

	override func viewWillDisappear(_ animated: Bool) {
		activityVM.destroyTimer()
		activityVM.destroyPrevData()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(activityVM.pageTitle)
	}

	private func setupView() {
		activityColectionView = ActivityCollectionView(
			activityVM: activityVM,
			openActivityDetailsClosure: { [weak self] activityDetails in
				self?.openActivityDetailsPage(activityDetails: activityDetails)
			}
		)
		activityEmptyStateView = ActivityEmptyStateView(
			titleText: activityVM.noActivityMessage,
			titleImageName: activityVM.noActivityIconName
		)
		view = activityColectionView
	}

	private func openActivityDetailsPage(activityDetails: ActivityCellViewModel) {
		let navigationVC = UINavigationController()
		let activityDetailsVC = ActivityDetailsViewController(activityDetails: activityDetails)
		navigationVC.viewControllers = [activityDetailsVC]
		present(navigationVC, animated: true)
	}

	private func setupBindings() {
        PendingActivitiesManager.shared.$pendingActivitiesList.sink { pendingActivities in
            print("heh", pendingActivities)
        }.store(in: &cancellables
        )
		activityVM.$userActivities.sink { [weak self] activities in
			guard let isActvitiesEmpty = activities?.isEmpty else {
				self?.view = self?.activityColectionView
				return
			}
			if isActvitiesEmpty {
				self?.view = self?.activityEmptyStateView
			} else {
				self?.view = self?.activityColectionView
			}
		}.store(in: &cancellables)
	}
}
