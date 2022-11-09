//
//  PinoButtonStyle.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public extension PinoButton {
    
    // Specifies a visual theme of the button
    struct Style: Equatable {
        
        public let titleColor: UIColor
        public let backgroundColor: UIColor
        public let borderColor: UIColor?

    }
}

// MARK: - Custom Button Styles

public extension PinoButton.Style {
    
    static let active = PinoButton.Style(
        titleColor: .white,
        backgroundColor: .pino.primary,
        borderColor: .clear
    )
    
    static let deactive = PinoButton.Style(
        titleColor: .secondaryLabel,
        backgroundColor: .pino.background,
        borderColor: .clear
    )
    
    static let success = PinoButton.Style(
        titleColor: .white,
        backgroundColor: .pino.successGreen,
        borderColor: .clear
    )
    
    static let delete = PinoButton.Style(
        titleColor: .white,
        backgroundColor: .pino.ErrorRed,
        borderColor: .clear
    )
    
    static let secondary = PinoButton.Style(
        titleColor: .pino.primary,
        backgroundColor: .clear,
        borderColor: .pino.primary
    )

    static let loading = PinoButton.Style(
        titleColor: .white,
        backgroundColor: .pino.green3,
        borderColor: .clear
    )

}

