//
//  InternetConnectivity.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/6/23.
//

import Combine
import Foundation
import Hyperconnectivity

class InternetConnectivity {
	// MARK: - Private Properties

	private var cancellable: AnyCancellable?
	public var isCheckingConnectivity: Bool?

	// MARK: - Public Properties

	@Published
	public var isConnected: Bool?

	// MARK: - Initializers

	init() {
		startConnectivityChecks()
	}

	// MARK: - Private Methods

	private func startConnectivityChecks() {
		isCheckingConnectivity = true
		cancellable = Hyperconnectivity.Publisher()
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
			.sink(receiveCompletion: { [weak self] _ in
				self?.stopConnectivityChecks()
			}, receiveValue: { [weak self] connectivityResult in
				self?.updateConnectionStatus(connectivityResult)
			})
	}

	private func stopConnectivityChecks() {
		cancellable?.cancel()
		isCheckingConnectivity = false
	}

	private func updateConnectionStatus(_ result: ConnectivityResult) {
		if isConnected != result.isConnected {
			isConnected = result.isConnected
		}
	}
}
