//
//  APIService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

protocol UsersAPIService {
	func users() -> AnyPublisher<Users, APIError>
    func userDetail(id: String) -> AnyPublisher<UserModel, APIError>
}

#warning("These models are temporary and will be deleted")
// Temorary models to better get familiar with our networking system
// MARK: - Welcome
struct Users: Codable {
    let page, perPage, total, totalPages: Int
    let users: [UserModel]

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case users = "data"
    }
}

// MARK: - Datum
struct UserModel: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

