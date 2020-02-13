//
//  NetworkingError.swift
//  Networking
//
//  Created by Carlos Henrique Salvador on 17/11/19.
//  Copyright © 2019 Carlos Henrique Salvador. All rights reserved.
//

import Foundation

private let domain = "NetworkingError"

// MARK: - Networking Errors

public enum NetworkingError: Error {
    
    case unknown
    case unexpected
    case urlRequest(URLRequestError)
    case serializationError(Error)
    case noData
    case invalidURL
    
    public var code: Int {
        switch self {
        case .unknown:
            return 10
        case .unexpected:
            return 11
        case let .urlRequest(requestError):
            return requestError.code
        case .serializationError:
            return 12
        case .noData:
            return 13
        case .invalidURL:
            return 14
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .unknown:
            return "An unknown error has occurred in the service."
        case .unexpected:
            return "An unexpected error has occurred in the service."
        case .urlRequest:
            return "There was an error in the URLRequest."
        case .serializationError:
            return "A serialization error has occurred."
        case .noData:
            return "No data was found."
        case .invalidURL:
            return "The URL is invalid."
        }
    }
    
    public var rawError: NSError {
        switch self {
        case let .urlRequest(urlError):
            return urlError.rawError
        case let .serializationError(error):
            return error as NSError
        default:
            return NSError(domain: domain, code: code, description: localizedDescription)
        }
    }
    
}

