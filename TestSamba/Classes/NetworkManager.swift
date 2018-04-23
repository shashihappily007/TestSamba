//
//  NetworkManager.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 18/04/18.
//

import Foundation

internal class NetworkManager
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
        let urlStr = "\(request.base.rawValue)\(request.endPoint.rawValue)"
        guard let url = URL.init(string: urlStr) else { throw NetworkError.invalidURL(urlStr) }
        var urlRequest = URLRequest.init(url: url, cachePolicy: request.cachePolicy!, timeoutInterval: request.timeout!)
        if let urlParam = request.urlParams
        {
            let query_params = urlParam.map({ (element) -> URLQueryItem in
                var paramValue : String = ""
                if element.value is String
                {
                    let value  = element.value as! String
                    paramValue = value
                }
                if element.value is [String : Any]
                {
                    let value = element.value as! [String : Any]
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    {
                        if let jsonStr = String(data : jsonData, encoding : String.Encoding.utf8)
                        {
                            paramValue = jsonStr
                        }
                    }
                }
                return URLQueryItem(name: element.key, value: paramValue)
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
        return urlRequest
    }
}

internal typealias ParametersDict = [String : Any]
internal typealias HeadersDict = [String: String]

internal struct Request
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

