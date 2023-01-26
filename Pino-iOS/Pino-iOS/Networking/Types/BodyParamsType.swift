//
//  BodyParamsType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/26/23.
//

import Foundation

// Types of params that can be passed to network layer
// Either a dictionary or an object type
public enum BodyParamsType {
    case json(HTTPParameters)
    case object(Encodable)
}
