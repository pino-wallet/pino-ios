//
//  EnterInviteCodeViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/30/23.
//

import Combine
import Foundation
import UIKit

class EnterInviteCodeViewModel {
	// MARK: - Public Properties

	public let navbarDismissImageName = "close"
	public let titleText = "Enter invite code"
	public let describtionText = "Please enter your invitation code to access Pino"
	public let nextButtonText = "Next"
	public let getCodeText = "How i get one?"
	public let codePlaceHolder = "CODE"
	public let invalidCodeError = "Invalid code!"

	public enum InviteCodeStatus: Int {
		case sucess = 200
		case notFound = 404
		case alreadyUsed = 409
	}

	@Published
	public var inviteCodeStatus: InviteCodeStatus?

	// MARK: - Private Properties

	private let accountingAPI = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let cloudKitKeyManager = CloudKitKeyStoreManager(key: "inviteCode")

	// MARK: - Public Methods

	public func activateDeviceForBeta(inviteCode: String) {
		accountingAPI.activateDeviceWithInviteCode(inviteCode: inviteCode).sink { completed in
			switch completed {
			case .finished:
				print("Info received successfully")
			case let .failure(error):
				print(error)
				switch error {
				case let APIError.failedWith(statusCode):
					self.inviteCodeStatus = InviteCodeStatus(rawValue: statusCode) ?? .notFound
				case APIError.notFound:
					self.inviteCodeStatus = .notFound
				default:
					self.inviteCodeStatus = .notFound
				}
			}
		} receiveValue: { response in
			self.inviteCodeStatus = .sucess
			self.saveDeviceID()
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func saveDeviceID() {
		let deviceID = UIDevice.current.identifierForVendor!.uuidString
		cloudKitKeyManager.setValue(deviceID)
	}
}
