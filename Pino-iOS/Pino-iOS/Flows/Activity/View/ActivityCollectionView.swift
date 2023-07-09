//
//  ActivityCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import UIKit

class ActivityCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var activityVM: ActivityViewModel
	private var separatedActivities: ActivityHelper.separatedActivitiesType = []
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(activityVM: ActivityViewModel) {
		self.activityVM = activityVM

		let flowLayoutView = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayoutView)
		flowLayoutView.collectionView?.backgroundColor = .Pino.background
		flowLayoutView.collectionView?.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

		configureCollectionView()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.cellID)
		register(
			ActivityHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ActivityHeaderView.viewReuseID
		)

		delegate = self
		dataSource = self
	}

	private func setupBindings() {
		activityVM.$userActivities.sink { acitivities in
			let activityHelper = ActivityHelper()
			self.separatedActivities = activityHelper.separateActivitiesByTime(activities: acitivities)
			self.reloadData()
		}.store(in: &cancellables)
	}
}

extension ActivityCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 72)
	}
}

extension ActivityCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		separatedActivities.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		separatedActivities[section].activities.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let activityCell = dequeueReusableCell(
			withReuseIdentifier: ActivityCell.cellID,
			for: indexPath
		) as! ActivityCell
		activityCell.activityCellVM = separatedActivities[indexPath.section].activities[indexPath.item]
		return activityCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let activityHeader = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ActivityHeaderView.viewReuseID,
			for: indexPath
		) as! ActivityHeaderView
		activityHeader.titleText = separatedActivities[indexPath.section].title
		return activityHeader
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		let indexPath = IndexPath(row: 0, section: section)
		let headerView = self.collectionView(
			collectionView,
			viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
			at: indexPath
		)
		return headerView.systemLayoutSizeFitting(
			CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
	}
}
