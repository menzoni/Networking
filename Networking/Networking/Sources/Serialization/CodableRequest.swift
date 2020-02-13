//
//  CodableRequest.swift
//  Network
//
//  Created by Carlos Henrique Salvador on 20/10/19.
//  Copyright © 2019 Carlos Henrique Salvador. All rights reserved.
//

import Foundation

public protocol CodableRequest: CodableSerialize, NetworkingService {
    
    func requestCodable<T: Codable>(
        _ request: NetworkRequest,
        ofType type: T.Type,
        completion: @escaping (Result<T, NetworkingError>) -> Void)
}

extension CodableRequest {
    
    public func requestCodable<T: Codable>(
        _ request: NetworkRequest,
        ofType type: T.Type,
        completion: @escaping (Result<T, NetworkingError>) -> Void
    ) {
        dispatcher.execute(networkRequest: request) { result in
            self.serializeCodable(result, responseType: type, completion: completion)
        }
    }
    
}

