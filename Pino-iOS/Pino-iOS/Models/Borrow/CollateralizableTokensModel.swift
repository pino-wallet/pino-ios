// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct CollateralizableTokenDetailsModel: Codable {
    let tokenID: String
    let welcomeProtocol: ProtocolClass

    enum CodingKeys: String, CodingKey {
        case tokenID = "token_id"
        case welcomeProtocol = "protocol"
    }
    
    struct ProtocolClass: Codable {
    let name, logo: String
}
    
}



typealias CollateralizableTokensModel = [CollateralizableTokenDetailsModel]
