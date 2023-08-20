//
//  PromiseKit+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import PromiseKit

/// Utitlity function to attemp multiple times for a promise
func attempt<T>(
	maximumRetryCount: Int = 3,
	delayBeforeRetry: DispatchTimeInterval = .microseconds(500),
	_ body: @escaping () -> Promise<T>
) -> Promise<T> {
	var attempts = 0
	func attempt() -> Promise<T> {
		attempts += 1
		return body().recover { error -> Promise<T> in
			guard attempts < maximumRetryCount else { throw error }
			return after(delayBeforeRetry).then(attempt)
		}
	}
	return attempt()
}
