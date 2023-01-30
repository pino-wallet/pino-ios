//
//  EndpointType.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/30/23.
//

import Foundation

// Each endpoint in Test should conform to EndpointType protocol
protocol EndpointType {
    var path: String { get }
    var stubPath: String { get }
}
