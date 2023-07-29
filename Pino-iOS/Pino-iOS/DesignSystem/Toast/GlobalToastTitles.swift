//
//  GlobalToastTitles.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/29/23.
//

enum GlobalToastTitles {
    
    case copy
    case tryAgainToastTitle
    
    public var message: String {
        switch self {
        case .copy:
            return "Copied!"
        case .tryAgainToastTitle:
            return "Please try again!"
        }
    }
}
