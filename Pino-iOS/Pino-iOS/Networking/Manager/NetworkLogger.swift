//
//  NetworkLogger.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/9/23.
//

import Foundation

struct NetworkLogger {
    
   static func log(request: URLRequest) {
        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod!)" : ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ??
            "Can't render body; not utf8 encoded"
            requestLog += "\n\(bodyString)\n"
        }
        
        requestLog += "\n------------------------->\n"
        print(requestLog)
    }
    
}
