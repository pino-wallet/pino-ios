//
//  HapticManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/22/24.
//

import Foundation
import UIKit

class HapticManager {
	// MARK: - Public Properties

	public enum HapticType {
		case heavyImpact
		case mediumImpact
		case lightImpact
		case selectionChanged
		case errorNotification
		case successNotification
	}

	// MARK: - Public Methods

	public func run(type: HapticType) {
		switch type {
		case .heavyImpact:
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
		case .mediumImpact:
			let generator = UIImpactFeedbackGenerator(style: .medium)
			generator.impactOccurred()
		case .lightImpact:
			let generator = UIImpactFeedbackGenerator(style: .light)
			generator.impactOccurred()
		case .selectionChanged:
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
		case .errorNotification:
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.error)
		case .successNotification:
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.success)
		}
	}
}
