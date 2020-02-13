//
//  DefaultURLRequestBuilder.swift
//  Network
//
//  Created by Carlos Henrique Salvador on 19/10/19.
//  Copyright © 2019 Carlos Henrique Salvador. All rights reserved.
//

import Foundation

public protocol URLRequestBuilder {
    
    // MARK: - Initialization
    init(request: NetworkRequest)
    
    // MARK: - Builder methods

    @discardableResult
    func set(method: HTTPMethod) -> Self
    
    @discardableResult
    func set(path: String) -> Self
    
    @discardableResult
    func set(headers: [String: String]?) -> Self
    
    @discardableResult
    func set(parameters: Parameters?) -> Self

    func build() throws -> URLRequest
}

public final class DefaultURLRequestBuilder: URLRequestBuilder {
    
    // MARK: - Properties
    
    private var baseURL: URL
    private var path: String?
    private var method: HTTPMethod = .get
    private var headers: HTTPHeaders?
    private var parameters: Parameters?
    
    // MARK: - Initialization
    public init(request: NetworkRequest) {
        self.baseURL = request.baseURL
        self.path = request.path
        self.method = request.method
        self.headers = request.headers
        self.parameters = request.parameters
    }
    
    // MARK: - Builder methods
    @discardableResult
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    public func set(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }

    @discardableResult
    public func set(parameters: Parameters?) -> Self {
        self.parameters = parameters
        return self
    }
    
    /// Builds an URLRequest as previously defined.
    ///
    /// - Returns: A configured URLRequest.
    public func build() throws -> URLRequest {
        
        var url = baseURL
        if let path = path {
            url = baseURL.appendingPathComponent(path)
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 100)
        
        urlRequest.httpMethod = method.name
        setupRequest(&urlRequest, with: parameters)
        
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
    // MARK: - Private Functions
    
    private func setupRequest(_ request: inout URLRequest, with parameters: Parameters?) {
        if let parameters = parameters {
            configureQueryParameters(parameters, for: &request)
        }
    }
    
    private func configureQueryParameters(_ parameters: Parameters?, for request: inout URLRequest) {
        if let urlParameters = parameters,
            let url = request.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = urlComponents.url
        }
    }
}
