import Foundation

private struct DataTaskResponse {
    let data: Data?
    let error: Error?
    let httpResponse: HTTPURLResponse
}

public protocol URLSessionDispatch {
    func execute(networkRequest: NetworkRequest, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void)
}

public final class URLSessionDispatcher: URLSessionDispatch {
    
    // MARK: - Properties
    let session: URLSession
    let requestBuilderType: URLRequestBuilder.Type
    
    // MARK: - Initialization
    public required init(
        session: URLSession = URLSession.shared,
        requestBuilderType: URLRequestBuilder.Type = DefaultURLRequestBuilder.self
    ) {
        self.session = session
        self.requestBuilderType = requestBuilderType
    }
    
    // MARK: - Functions
    public func execute(networkRequest: NetworkRequest, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void) {
        
        do {
            let urlRequest = try requestBuilderType
                .init(request: networkRequest)
                .build() as URLRequest
            
            let dataTask = session.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    completion(.failure(.invalidHTTPURLResponse))
                    return
                }
                
                let dataTaskResponse = DataTaskResponse(
                    data: data,
                    error: error,
                    httpResponse: httpResponse
                )
                
                if let urlRequestError = self?.parseErrors(in: dataTaskResponse) {
                    completion(.failure(urlRequestError))
                } else {
                    guard let data = data else {
                        completion(.success(nil))
                        return
                    }
                    completion(.success(data))
                }
            }
            dataTask.resume()
            
        } catch {
            completion(.failure(.requestBuilderFailed))
        }
    }
    
    // MARK: - Private Functions
    private func parseErrors(in dataTaskResponse: DataTaskResponse) -> URLRequestError? {
        
        let statusCode = dataTaskResponse.httpResponse.statusCode
        
        if (200...299 ~= statusCode) == false {
            
            guard dataTaskResponse.error == nil else {
                return .unknown
            }
            
            guard 400...499 ~= statusCode, let data = dataTaskResponse.data, let jsonString = String(data: data, encoding: .utf8) else {
                return .unknown
            }
            
            debugPrint(jsonString)
            return .withData(data, dataTaskResponse.error)
            
        }
        
        return nil
        
    }
}
