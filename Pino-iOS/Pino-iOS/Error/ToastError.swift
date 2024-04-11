//
//  ToastMessageError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/11/24.
//

import Foundation

protocol ToastError: Error {
	var toastMessage: String { get }
}
