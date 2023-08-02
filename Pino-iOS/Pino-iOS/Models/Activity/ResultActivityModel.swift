// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement

enum ResultActivityModel: Decodable, Encodable {

    case swap(ActivityModelProtocol)
    case transfer(ActivityModelProtocol)
    case transfer_from(ActivityModelProtocol)
    case unknown(UnknownActivityModel?)
    
	enum CodingKeys: String, CodingKey {
        case type
	}
        
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            
            
            switch ActivityType(rawValue: type) {
            case .transfer_from:
                let transferActivity = try ActivityTransferModel(from: decoder)
                self = .transfer(transferActivity)
            case .swap:
                let swapActivity = try ActivitySwapModel(from: decoder)
                self = .swap(swapActivity)
            case .transfer:
                let transferActivity = try ActivityTransferModel(from: decoder)
                self = .transfer(transferActivity)
            default:
                self = .unknown(nil)
            }
    }
    
    func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           
           switch self {
           case .swap(let swapActivity):
               try container.encode(ActivityType.swap.rawValue, forKey: .type)
               try swapActivity.encode(to: encoder)
           case .transfer(let transferActivity):
               try container.encode(ActivityType.transfer.rawValue, forKey: .type)
               try transferActivity.encode(to: encoder)
           case .transfer_from(let transferActivity):
               try container.encode(ActivityType.transfer_from.rawValue, forKey: .type)
               try transferActivity.encode(to: encoder)
           case .unknown(let nilDetails):
               try nilDetails.encode(to: encoder)
           }
       }
}


struct UnknownActivityModel: Codable {
}

typealias ActivitiesModel = [ResultActivityModel]
