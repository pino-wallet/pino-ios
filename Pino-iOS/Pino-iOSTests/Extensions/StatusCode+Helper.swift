//
//  StatusCode+Helper.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/14/23.
//

import Foundation

extension StatusCode {
    
    var isSuccess: Bool {
        (200..<300).contains(self)
    }
    
}
