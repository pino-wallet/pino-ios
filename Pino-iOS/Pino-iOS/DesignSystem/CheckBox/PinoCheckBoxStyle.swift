//
//  PinoCheckBoxStyle.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public extension PinoCheckBox {
    
    /// Specifies a visual theme of the checkBox
    struct Style: Equatable {
        
        public let uncheckedImage: UIImage?
        public let checkedImage: UIImage?
        public let unchekedTintColor: UIColor
        public let checkedTintColor: UIColor

    }
}

// MARK: - Custom CheckBox Styles

public extension PinoCheckBox.Style {
    
    static let defaultStyle = PinoCheckBox.Style(
        uncheckedImage: UIImage(systemName: "square"),
        checkedImage: UIImage(systemName: "checkmark.square.fill"),
        unchekedTintColor: .Pino.gray3,
        checkedTintColor: .Pino.primary
    )
    
    static let deactive = PinoCheckBox.Style(
        uncheckedImage: UIImage(systemName: "checkmark.square"),
        checkedImage: UIImage(systemName: "checkmark.square.fill"),
        unchekedTintColor: .Pino.gray3,
        checkedTintColor: .Pino.primary
    )

}
