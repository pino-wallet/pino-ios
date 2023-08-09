//
//  ActivityViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation

class ActivityViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Recent activity"
	public let noActivityMessage = "There is no activity"
	public let noActivityIconName = "empty_activity"
	public let errorFetchingToastMessage = "Error fetching activities from server"

	@Published
	public var userActivities: [ActivityCellViewModel]? = nil
	@Published
	public var newUserActivities: [ActivityCellViewModel] = []
    @Published
    public var deletedUserActivities: [ActivityCellViewModel] = []

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()
	private var cancellables = Set<AnyCancellable>()
    private var pendingActivitiesCancellable = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var prevActivities: [ActivityModelProtocol] = []
    private var prevAccountAddress: String!
    private var currentDeletedActivities: [ActivityModelProtocol] = []
    private var isFirstTime: Bool = true

	// MARK: - Public Properties

	public func getUserActivitiesFromVC() {
        if prevAccountAddress != walletManager.currentAccount.eip55Address {
            refreshPrevData()
            setPrevAccountAddress()
        }
        setupBindings()
		setupRequestTimer()
		requestTimer?.fire()
	}

	public func refreshUserActvities() {
		requestTimer?.fire()
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}
    
    public func cancellPendingActivitiesBinding() {
        pendingActivitiesCancellable.removeAll()
    }
    
    // MARK: - Initializers
    init() {
        setPrevAccountAddress()
    }

	// MARK: - Private Methods

	private func setupRequestTimer() {
		destroyTimer()
		requestTimer = Timer.scheduledTimer(
			timeInterval: 12,
			target: self,
			selector: #selector(getUserActivities),
			userInfo: nil,
			repeats: true
		)
	}
    
    private func setupBindings() {
        PendingActivitiesManager.shared.$pendingActivitiesList.sink { pendingActivities in
            guard self.userActivities != nil else {
                return
            }
            
            let newPendingActivities = pendingActivities.filter { activity in
                !self.prevActivities.contains(where: { $0.txHash == activity.txHash })
            }
            self.newUserActivities = newPendingActivities.compactMap {
                ActivityCellViewModel(activityModel: $0)
            }
            self.prevActivities.append(contentsOf: newPendingActivities)
            
            let prevPendingActivities = self.prevActivities.filter { activity in
                activity.failed == nil
            }
            if prevPendingActivities.count > pendingActivities.count {
                let deletedActivities = prevPendingActivities.filter { activity in
                    !pendingActivities.contains(where: { $0.txHash == activity.txHash })
                }
                self.currentDeletedActivities = deletedActivities
                self.requestTimer?.fire()
            }
        }.store(in: &pendingActivitiesCancellable)
    }
    
    private func refreshPrevData() {
        userActivities = nil
        prevActivities = []
        newUserActivities = []
        isFirstTime = true
    }
    
    private func setPrevAccountAddress() {
        prevAccountAddress = walletManager.currentAccount.eip55Address
    }

	@objc
	private func getUserActivities() {
		let userAddress = walletManager.currentAccount.eip55Address
		activityAPIClient.allActivities(userAddress: userAddress).sink { completed in
			switch completed {
			case .finished:
				print("User activities received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { [weak self] activities in
                var iteratedActivities = self?.activityHelper.iterateActivitiesFromResponse(activities: activities) ?? []
                if ((self?.isFirstTime) != nil) {
                    iteratedActivities.append(contentsOf: PendingActivitiesManager.shared.pendingActivitiesList)
                    self?.isFirstTime = false
                }
                if self?.userActivities == nil || (self?.userActivities!.isEmpty)! {
                    self?.userActivities = iteratedActivities.compactMap {
                        ActivityCellViewModel(activityModel: $0)
                    }
                    self?.prevActivities = iteratedActivities
                } else {
                    var newActivities: [ActivityModelProtocol] = []
                    newActivities = iteratedActivities.filter { activity in
                        !self!.prevActivities.contains { activity.txHash == $0.txHash }
                    }
                    self?.newUserActivities = newActivities.compactMap {
                        ActivityCellViewModel(activityModel: $0)
                    }
                    self?.prevActivities.append(contentsOf: newActivities)
                    
                    if !(self?.currentDeletedActivities.isEmpty)! {
                        
                        for deletedActivity in self?.currentDeletedActivities ?? [] {
                            self?.prevActivities.removeAll(where: { $0.txHash == deletedActivity.txHash })
                        }
                        
                        self?.deletedUserActivities = self?.currentDeletedActivities.compactMap {
                            ActivityCellViewModel(activityModel: $0)
                        } ?? []
                        
                        self?.currentDeletedActivities = []
                    }
                    
                }
		}.store(in: &cancellables)
	}
}
