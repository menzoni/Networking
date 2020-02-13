//
//  CodableSerialization.swift
//  Network
//
//  Created by Carlos Henrique Salvador on 20/10/19.
//  Copyright © 2019 Carlos Henrique Salvador. All rights reserved.
//

import Foundation

public protocol CodableSerialize {
    func serializeCodable<T: Codable>(
        _ result: Result<Data?, URLRequestError>,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkingError>) -> Void)
}

extension CodableSerialize {
    
    public func serializeCodable<T: Codable>(
        _ result: Result<Data?, URLRequestError>,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkingError>) -> Void
    ) {
        
        switch result {
        case let .success(data):
            handleSuccess(
                data: data,
                responseType: T.self,
                completion: completion)
        case let .failure(error):
            completion(.failure(.urlRequest(error)))
        }
        
    }
    
    private func handleSuccess<T: Codable>(
        data: Data?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkingError>) -> Void
    ) {
        guard let data = data else {
            completion(.failure(.noData))
            return
        }
        
        do {
            let serializedResponse = try JSONDecoder().decode(responseType.self, from: data)
            completion(.success(serializedResponse))
        } catch {
            completion(.failure(.serializationError(error)))
        }
        
    }
    
}
