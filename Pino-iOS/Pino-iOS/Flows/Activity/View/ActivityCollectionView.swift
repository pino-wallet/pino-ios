//
//  ActivityCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import UIKit

class ActivityCollectionView: UICollectionView {
	// MARK: - TypeAliases

	typealias openActivityDetailsClosureType = (_ activityDetails: ActivityCellViewModel) -> Void

	// MARK: - Closures

	public var openActivityDetailsClosure: openActivityDetailsClosureType

	// MARK: - Private Properties

	private let activityRefreshControll = UIRefreshControl()
	private var activityVM: ActivityViewModel
	private var separatedActivities: ActivityHelper.SeparatedActivitiesType = []
	private var cancellables = Set<AnyCancellable>()
	private var showLoading = true
	private var globalAssetsList: [AssetViewModel]?

	// MARK: - Initializers

	init(activityVM: ActivityViewModel, openActivityDetailsClosure: @escaping openActivityDetailsClosureType) {
		self.activityVM = activityVM
		self.openActivityDetailsClosure = openActivityDetailsClosure

		let flowLayoutView = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayoutView)
		flowLayoutView.collectionView?.backgroundColor = .Pino.background
		flowLayoutView.collectionView?.contentInset = UIEdgeInsets(top: 54, left: 0, bottom: 24, right: 0)
		flowLayoutView.minimumLineSpacing = 8

		configureCollectionView()
		setupBindings()
		setupRefreshControl()
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
		activityVM.$userActivities.combineLatest(GlobalVariables.shared.$manageAssetsList)
			.sink { activities, assetsList in
				if self.globalAssetsList == nil {
					self.globalAssetsList = assetsList
				}
				guard let userActivities = activities else {
					self.showLoading = true
					self.reloadData()
          self.contentInset = UIEdgeInsets(top: 54, left: 0, bottom: 24, right: 0)
					self.refreshControl?.endRefreshing()
					return
				}
				let activityHelper = ActivityHelper()
				self.separatedActivities = activityHelper.separateActivitiesByTime(activities: userActivities)
				if self.globalAssetsList != nil {
					self.showLoading = false
					self.reloadData()
          self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
					self.refreshControl?.endRefreshing()
				}
			}.store(in: &cancellables)

		activityVM.$newUserActivities.sink { newActivities in
			guard !newActivities.isEmpty else {
				self.refreshControl?.endRefreshing()
				return
			}
			let newSeparatedActivities = activityHelper.separateActivitiesByTime(activities: newActivities)
			let newActivitiesInfo = activityHelper.getNewActivitiesInfo(
				separatedActivities: self.separatedActivities,
				newSeparatedActivities: newSeparatedActivities
			)
			self.performBatchUpdates({
				self.separatedActivities = newActivitiesInfo.finalSeparatedActivities
				if !newActivitiesInfo.sections.isEmpty {
					for newActivitySection in newActivitiesInfo.sections {
						self.insertSections(newActivitySection)
						self.collectionViewLayout.invalidateLayout()
					}
				}
				self.insertItems(at: newActivitiesInfo.indexPaths)
				self.collectionViewLayout.invalidateLayout()
			}, completion: nil)
			self.refreshControl?.endRefreshing()
		}.store(in: &cancellables)
	}

	private func refreshData() {
		activityVM.refreshUserActvities()
	}

	private func setupRefreshControl() {
		indicatorStyle = .white
		activityRefreshControll.tintColor = .Pino.green2
		activityRefreshControll.addAction(UIAction(handler: { _ in
			self.refreshData()
		}), for: .valueChanged)
		refreshControl = activityRefreshControll
	}
}

extension ActivityCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		openActivityDetailsClosure(
			separatedActivities[indexPath.section].activities[indexPath.item]
		)
	}
}

extension ActivityCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 0)
	}
}

extension ActivityCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if showLoading {
			return 1
		} else {
			return separatedActivities.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if showLoading {
			return 7
		} else {
			return separatedActivities[section].activities.count
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let activityCell = dequeueReusableCell(
			withReuseIdentifier: ActivityCell.cellID,
			for: indexPath
		) as! ActivityCell
		if showLoading {
			activityCell.activityCellVM = nil
			activityCell.showSkeletonView()
		} else {
			activityCell.activityCellVM = separatedActivities[indexPath.section].activities[indexPath.item]
			activityCell.activityCellVM?.globalAssetsList = globalAssetsList
			activityCell.hideSkeletonView()
		}
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
		if !showLoading {
			activityHeader.titleText = separatedActivities[indexPath.section].title
		}

		return activityHeader
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		if !showLoading {
			return CGSize(width: collectionView.frame.width, height: 46)
		} else {
			return CGSize(width: 0, height: 0)
		}
	}
}
