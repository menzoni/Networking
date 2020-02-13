import Foundation

public typealias QueryStringParameters = [String: String]
public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String:String]


/// Supported types for HTTP methods
public enum HTTPMethod: String {
    
    case post
    case get
    
    /// Returns the name of the method to be used in the request.
    public var name: String {
        return rawValue.uppercased()
    }
}

public protocol NetworkRequest {
    var baseURL: URL { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}

public protocol NetworkingService {
    var dispatcher: URLSessionDispatch { get }
}
