//
//  ActivityDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import UIKit

class ActivityDetailsViewController: UIViewController {
	// MARK: - Private Properties

	private var activityDetailsView: ActivityDetailsView!
	private var activityDetailsVM: ActivityDetailsViewModel!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
        if isBeingPresented || isMovingToParent {
            activityDetailsVM.getActivityDetailsFromVC()
        }
	}

	override func viewDidDisappear(_ animated: Bool) {
		activityDetailsVM.destroyTimer()
	}

	// MARK: - Initializers

	init(activityDetails: ActivityCellViewModel) {
		self.activityDetailsVM = ActivityDetailsViewModel(activityDetails: activityDetails)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		activityDetailsView = ActivityDetailsView(
			activityDetailsVM: activityDetailsVM,
			presentActionSheet: { [weak self] actionSheet in
				self?.present(actionSheet, animated: true)
			},
			activityDetailsHeader: activityDetailsVM.properties
				.uiType == .swap ? ActivitySwapHeaderView(activityDetailsVM: activityDetailsVM) :
				ActivityDetailsHeaderView(activityDetailsVM: activityDetailsVM)
		)

		view = activityDetailsView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(activityDetailsVM.properties.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: activityDetailsVM.dismissNavigationIconName),
			style: .plain,
			target: self,
			action: #selector(dismissPage)
		)
	}

	@objc
	private func dismissPage() {
		dismiss(animated: true)
	}
}
