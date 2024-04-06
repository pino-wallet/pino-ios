//
//  UILabel+Extension.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/6/24.
//

import Foundation
import UIKit


extension UILabel {
    public func setFootnoteText(prefixText: String, boldText: String, suffixText: String) {
        let normalAttrs = [NSAttributedString.Key.font: UIFont.PinoStyle.mediumFootnote, NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel]
        let boldAttrs = [NSAttributedString.Key.font: UIFont.PinoStyle.semiboldFootnote, NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel]
        let prefixAttributedString = NSMutableAttributedString(string: prefixText, attributes: normalAttrs as [NSAttributedString.Key : Any])
        let boldAttributedString = NSMutableAttributedString(string: boldText, attributes: boldAttrs as [NSAttributedString.Key : Any])
        let suffixAttributedString = NSMutableAttributedString(string: suffixText, attributes: normalAttrs as [NSAttributedString.Key : Any])
        let resultAttributedString = NSMutableAttributedString()
        resultAttributedString.append(prefixAttributedString)
        resultAttributedString.append(boldAttributedString)
        resultAttributedString.append(suffixAttributedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        resultAttributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: resultAttributedString.length)
        )
        
        attributedText = resultAttributedString
        numberOfLines = 0
    }
}
