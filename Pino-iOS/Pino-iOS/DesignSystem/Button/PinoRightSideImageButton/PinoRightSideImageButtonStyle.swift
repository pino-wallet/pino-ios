//
//  PinoRightSideImageStyle.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/29/23.
//
import UIKit

extension PinoRightSideImageButton {
    // Specifies a visual theme of the button
    public struct Style {
        public let titleColor: UIColor
        public let backgroundColor: UIColor
        public let borderColor: UIColor?
    }
}

extension PinoRightSideImageButton.Style {
    public static let primary = PinoRightSideImageButton.Style(
        titleColor: .Pino.white,
        backgroundColor: .Pino.primary,
        borderColor: .clear
    )
    public static let clear = PinoRightSideImageButton.Style(
        titleColor: .Pino.primary,
        backgroundColor: .Pino.clear,
        borderColor: .clear
    )
}
