//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public enum HTTPTask {
    case request
    
    case requestParameters(
        bodyParameters: BodyParamsType?,
        bodyEncoding: ParameterEncoding,
        urlParameters: HTTPParameters?
    )
    
    case requestParametersAndHeaders(
        bodyParameters: BodyParamsType?,
        bodyEncoding: ParameterEncoding,
        urlParameters: HTTPParameters?,
        additionHeaders: HTTPHeaders
    )
    
    // case download, upload...etc
}

extension HTTPTask {
    
    public func configParams(_ request: inout URLRequest) throws {
        do {
            switch self {
            case .request:
                request.addJSONContentType()
            case let .requestParameters(
                bodyParameters,
                bodyEncoding,
                urlParameters
            ):
                
                try configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
                
            case let .requestParametersAndHeaders(
                bodyParameters,
                bodyEncoding,
                urlParameters,
                additionalHeaders
            ):
                request.addHeaders(additionalHeaders)
                try configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
            }
            
        } catch {
            throw error
        }
    }
    
    private func configureParameters(
        bodyParameters: BodyParamsType?,
        bodyEncoding: ParameterEncoding,
        urlParameters: HTTPParameters?,
        request: inout URLRequest
    ) throws {
        do {
            try bodyEncoding.encode(
                urlRequest: &request,
                bodyParameters: bodyParameters,
                urlParameters: urlParameters
            )
        } catch {
            throw error
        }
    }
}
