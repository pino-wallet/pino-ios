//
//  Environment.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum Environment {
	static var apiBaseURL: URL {
		URL(string: "https://cocoacasts-mock-api.herokuapp.com/api/vl")!
	}
}
