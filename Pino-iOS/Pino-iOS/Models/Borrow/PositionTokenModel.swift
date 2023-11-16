// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct PositionTokenModel: Codable {
    let positionID, tokenProtocol, underlyingToken: String

    enum CodingKeys: String, CodingKey {
        case positionID = "position_id"
        case tokenProtocol = "protocol"
        case underlyingToken = "underlying_token"
    }
}
