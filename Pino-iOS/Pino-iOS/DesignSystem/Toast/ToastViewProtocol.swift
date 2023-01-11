//
//  ToastViewProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/11/23.
//

import UIKit

protocol ToastView {
	associatedtype alignmentType
	associatedtype styleType
	var alignment: alignmentType { get set }
	var style: styleType { get set }
	var message: String? { get set }
	var image: UIImage? { get set }
	func showToast()
}
