// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

struct ActivityTokenModel: Codable {
	let amount, tokenID: String

	enum CodingKeys: String, CodingKey {
		case amount
		case tokenID = "id"
	}
}
