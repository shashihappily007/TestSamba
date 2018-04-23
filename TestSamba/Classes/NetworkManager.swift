//
//  NetworkManager.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 18/04/18.
//

import Foundation

public class NetworkManager
{
    private var session : URLSession
    public init()
    {
        self.session = URLSession.init(configuration: .default)
    }
    
    public func execute(request: Request, completionData: @escaping (_ data : [String : Any], _ statusCode : Int) -> Void) {
        let request = try? prepareUrlRequest(request: request)
        let task = self.session.dataTask(with: request!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            } else {

            }
        })
        task.resume()
    }
    
    private func prepareUrlRequest(request : Request) throws -> URLRequest
    {
        let urlStr = "\(request.base)\(request.endPoint)"
        guard let url = URL.init(string: urlStr) else { throw NetworkError.invalidURL(urlStr) }
        var urlRequest = URLRequest.init(url: url, cachePolicy: request.cachePolicy!, timeoutInterval: request.timeout!)
        if let urlParam = request.urlParams as? [String : String]
        {
            let query_params = urlParam.map({ (element) -> URLQueryItem in
                return URLQueryItem(name: element.key, value: element.value)
            })
            guard var components = URLComponents(string: urlStr) else {
                throw NetworkError.invalidURL(urlStr)
            }
            components.queryItems = query_params
            urlRequest.url = components.url
        }
        print("url sring \(urlRequest.url!)")
        //urlRequest.httpMethod = request.method.rawValue
        if let headers = request.headers
        {
            for (key, value) in headers
            {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
//        if let body = request.body
//        {
//            let bodyData = try? body.encodedData()
//            urlRequest.httpBody = bodyData
//        }
        return urlRequest
    }
}

public typealias ParametersDict = [String : Any]
public typealias HeadersDict = [String: String]

public struct Request
{
    public var base : BaseUrl
    public var endPoint: EndPoint
    public var method: String
    public var urlParams: ParametersDict?
    //public var body: RequestBody?
    public var headers: HeadersDict?
    public var cachePolicy: URLRequest.CachePolicy?
    public var timeout: TimeInterval?
    
    public init(base : BaseUrl,endpoint : EndPoint, urlParams : ParametersDict? = nil, headers : HeadersDict? = nil)
    {
        self.method = "GET"
        self.base = base
        self.endPoint = endpoint
        self.urlParams = urlParams
        self.headers = headers
        self.cachePolicy = .reloadIgnoringLocalCacheData
        self.timeout = 30.0
    }
}

public enum NetworkError : Error
{
    case invalidURL(_ : String)
}

