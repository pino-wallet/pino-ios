//
//  RecentAddressHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/28/24.
//

import Foundation


class RecentAddressHelper {
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let coreDataManager = CoreDataManager()
    private let pinoWalletManager = PinoWalletManager()
    // MARK: - Public Methods
    public func addNewRecentAddress(newRecentAddress: RecentAddressModel) {
        let userAccountList = coreDataManager.getAllWalletAccounts()
        guard userAccountList.first(where: { $0.eip55Address.lowercased() == newRecentAddress.address.lowercased() }) == nil else { return }
        var decodedRecentAddressList = getDecodedRecentAddressList()
        if let recentAddressIndex = decodedRecentAddressList.firstIndex(where: { $0.address.lowercased() == newRecentAddress.address.lowercased() }) {
            decodedRecentAddressList[recentAddressIndex].date = newRecentAddress.date
        } else {
            decodedRecentAddressList.append(newRecentAddress)
        }
        let encodedRecentAddressList = encodeRecentAddressList(recentAddressList: decodedRecentAddressList)
        userDefaults.setValue(encodedRecentAddressList, forKey: GlobalUserDefaultsKeys.recentSentAddresses.key)
    }
    
    
    
    public func getUserRecentAddresses() -> [RecentAddressModel] {
        removeOldRecentAddresses()
        let decodedRecentAddressList = getDecodedRecentAddressList()
        let filteredUserRecentAddressList = decodedRecentAddressList.filter { $0.userAddress.lowercased() == pinoWalletManager.currentAccount.eip55Address.lowercased() }
        return filteredUserRecentAddressList.sorted(by: {
            $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
        })
    }
    
    // MARK: - Private Methods
    
    private func removeOldRecentAddresses() {
        let decodedRecentAddressList = getDecodedRecentAddressList()
        let calendar = Calendar.current
        let numberOfDaysOfExpiration = 14
        let filteredRecentAddressList = decodedRecentAddressList.filter { calendar.dateComponents([.day], from: $0.date, to: Date()).day! < numberOfDaysOfExpiration }
        let encodedFilteredRecentAddressList = encodeRecentAddressList(recentAddressList: filteredRecentAddressList)
        userDefaults.setValue(encodedFilteredRecentAddressList, forKey: GlobalUserDefaultsKeys.recentSentAddresses.key)
    }
    
    private func getDecodedRecentAddressList() -> [RecentAddressModel] {
        let recentAddressList = userDefaults.value(forKey: GlobalUserDefaultsKeys.recentSentAddresses.key) as? Data
        let decodedRecentAddressList = decodeRecentAddressList(recentAddressEncodedList: recentAddressList)
        return decodedRecentAddressList
    }
    
    private func encodeRecentAddressList(recentAddressList: [RecentAddressModel]) -> Data {
        let encoder = JSONEncoder()
        do {
            let result = try encoder.encode(recentAddressList)
            return result
        } catch {
            fatalError("cant encode recent address list")
        }
    }
    
    private func decodeRecentAddressList(recentAddressEncodedList: Data?) -> [RecentAddressModel] {
        guard let recentAddressEncodedList else { return [] }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode([RecentAddressModel].self, from: recentAddressEncodedList)
            return result
        } catch {
            fatalError("cant decode recent address list")
        }
    }
    
}
