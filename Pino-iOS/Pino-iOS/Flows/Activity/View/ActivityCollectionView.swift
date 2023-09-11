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
	private var globalAssetsCancellable = Set<AnyCancellable>()
	private var showLoading = true
	private var globalAssetsList: [AssetViewModel]?

	// MARK: - Initializers

	init(activityVM: ActivityViewModel, openActivityDetailsClosure: @escaping openActivityDetailsClosureType) {
		self.activityVM = activityVM
		self.openActivityDetailsClosure = openActivityDetailsClosure

		let flowLayoutView = UICollectionViewFlowLayout(scrollDirection: .vertical)

		super.init(frame: .zero, collectionViewLayout: flowLayoutView)
		flowLayoutView.collectionView?.backgroundColor = .Pino.background
		flowLayoutView.collectionView?.contentInset = UIEdgeInsets(top: 46, left: 0, bottom: 24, right: 0)
		flowLayoutView.minimumLineSpacing = 8
		flowLayoutView.sectionHeadersPinToVisibleBounds = true

		configureCollectionView()
		setupBindings()
		setupRefreshControl()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    // MARK: - Public Methods
    public func toggleLoading(isLoading: Bool) {
        if isLoading {
            showLoading = true
            reloadData()
            contentInset = UIEdgeInsets(top: 46, left: 0, bottom: 24, right: 0)
            refreshControl?.endRefreshing()
        } else {
            showLoading = false
            reloadData()
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
            refreshControl?.endRefreshing()
        }
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
		let activityHelper = ActivityHelper()

		GlobalVariables.shared.$manageAssetsList.sink { assetsList in
			if self.globalAssetsList == nil {
				self.globalAssetsList = assetsList
				if self.activityVM.userActivities != nil {
					self.separatedActivities = activityHelper
						.separateActivitiesByTime(activities: self.activityVM.userActivities!)
					self.toggleLoading(isLoading: false)
				}
				self.globalAssetsCancellable.removeAll()
			}

		}.store(in: &globalAssetsCancellable)

		activityVM.$userActivities.sink { activities in
			guard let userActivities = activities else {
				return
			}

			if self.globalAssetsList != nil {
				self.separatedActivities = activityHelper.separateActivitiesByTime(activities: userActivities)
				self.toggleLoading(isLoading: false)
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

		activityVM.$shouldReplacedActivites.sink { shouldReplacedActivities in
			guard !shouldReplacedActivities.isEmpty else {
				return
			}
			let replacedActivitiesInfo = activityHelper.getReplacedActivitiesInfo(
				replacedActivities: shouldReplacedActivities,
				separatedActivities: self.separatedActivities
			)
			self.performBatchUpdates({
				self.separatedActivities = replacedActivitiesInfo.finalSeparatedActivities
				self.reloadItems(at: replacedActivitiesInfo.indexPaths)
				self.collectionViewLayout.invalidateLayout()
			}, completion: nil)

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
		if !showLoading {
			openActivityDetailsClosure(
				separatedActivities[indexPath.section].activities[indexPath.item]
			)
		}
	}
}

extension ActivityCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 64)
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
			if globalAssetsList != nil {
				activityCell.activityCellVM?.globalAssetsList = globalAssetsList!
			}
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
