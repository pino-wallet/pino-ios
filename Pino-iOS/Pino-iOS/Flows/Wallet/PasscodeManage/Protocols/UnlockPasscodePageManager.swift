//
//  UnlockPasscodePageManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/8/23.
//

import Foundation

protocol UnlockPasscodePageManager: PasscodeManagerPages {
	var faceIdTitle: String? { get }
	var useFaceIdTitle: String? { get }
	var useFaceIdIcon: String? { get }
}
