//
//  ParameterEncoderProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/26/23.
//

import Foundation

public protocol ParameterEncoder {
	func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws
	func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws
}
