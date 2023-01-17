//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws
}

public enum BodyParamsType {
    case json(Parameters)
    case object(Encodable)
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: BodyParamsType? = nil,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try encodeBodyParams(urlRequest: &urlRequest, params: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try encodeBodyParams(urlRequest: &urlRequest, params: bodyParameters)
            }
        }catch {
            throw error
        }
    }
    
    private func encodeBodyParams(urlRequest: inout URLRequest, params:BodyParamsType) throws {
        switch params {
        case .object(let object):
            try BodyParameterEncoder().encode(urlRequest: &urlRequest, with: object)
        case .json(let json):
            try BodyParameterEncoder().encode(urlRequest: &urlRequest, with: json)
        }
    }
    
}


public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
