//
//  RecentAddressHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/28/24.
//

import Foundation

class RecentAddressHelper {
	// MARK: - Private Properties

	private let recentAddressUserDefaultsManager = UserDefaultsManager(userDefaultKey: .recentSentAddresses)
	private let coreDataManager = CoreDataManager()
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Public Methods

	public func addNewRecentAddress(newRecentAddress: RecentAddressModel) {
		let userAccountList = coreDataManager.getAllWalletAccounts()
		guard userAccountList
			.first(where: { $0.eip55Address.lowercased() == newRecentAddress.address.lowercased() }) == nil else { return }
		var decodedRecentAddressList = getDecodedRecentAddressList()
		if let recentAddressIndex = decodedRecentAddressList
			.firstIndex(where: { $0.address.lowercased() == newRecentAddress.address.lowercased() }) {
			decodedRecentAddressList[recentAddressIndex].date = newRecentAddress.date
		} else {
			decodedRecentAddressList.append(newRecentAddress)
		}
		recentAddressUserDefaultsManager.setValue(value: decodedRecentAddressList)
	}

	public func getUserRecentAddresses() -> [RecentAddressModel] {
		removeOldRecentAddresses()
		let decodedRecentAddressList = getDecodedRecentAddressList()
		let filteredUserRecentAddressList = decodedRecentAddressList
			.filter { $0.userAddress.lowercased() == pinoWalletManager.currentAccount.eip55Address.lowercased() }
		return filteredUserRecentAddressList.sorted(by: {
			$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
		})
	}

	// MARK: - Private Methods

	private func removeOldRecentAddresses() {
		let decodedRecentAddressList = getDecodedRecentAddressList()
		let calendar = Calendar.current
		let numberOfDaysOfExpiration = 7
		let filteredRecentAddressList = decodedRecentAddressList
			.filter { calendar.dateComponents([.day], from: $0.date, to: Date()).day! < numberOfDaysOfExpiration }
		recentAddressUserDefaultsManager.setValue(value: filteredRecentAddressList)
	}

	private func getDecodedRecentAddressList() -> [RecentAddressModel] {
		let recentAddressList: [RecentAddressModel]? = recentAddressUserDefaultsManager.getValue()
		return recentAddressList ?? []
	}
}
