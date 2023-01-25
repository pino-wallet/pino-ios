//
//  StatusCode+Helper.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/24/23.
//

import Foundation

import Foundation

typealias StatusCode = Int

extension StatusCode {
 var isSuccess: Bool {
  (200 ..< 300).contains(self)
 }
}
