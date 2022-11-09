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
        
        public let UncheckedImage: UIImage?
        public let checkedImage: UIImage?
        public let unchekedTintColor: UIColor
        public let checkedTintColor: UIColor

    }
}

// MARK: - Custom CheckBox Styles

public extension PinoCheckBox.Style {
    
    static let defaultStyle = PinoCheckBox.Style(
        UncheckedImage: UIImage(systemName: "square"),
        checkedImage: UIImage(systemName: "checkmark.square.fill"),
        unchekedTintColor: .pino.gray3,
        checkedTintColor: .pino.primary
    )
    
    static let deactive = PinoCheckBox.Style(
        UncheckedImage: UIImage(systemName: "checkmark.square"),
        checkedImage: UIImage(systemName: "checkmark.square.fill"),
        unchekedTintColor: .pino.gray3,
        checkedTintColor: .pino.primary
    )

}
