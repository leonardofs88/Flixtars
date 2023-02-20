//
//  TMDBEndpointRouter.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation
import Alamofire

enum AppCongfig: String {
    case baseURL = "https://api.themoviedb.org"
    case baseImageUrl  = "https://image.tmdb.org"
    case v3 = "/3"
    
    static var apiKey: String {
        info["API_KEY"] as! String
    }

    private static var info : [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Info Plist file not found")
        }
    }
}

enum URLComponents: String {
    case contentType = "Content-Type"
    case accept = "Accept"
    case json = "application/json"
    case authentication = "Authorization"
}

enum QueryComponents: String {
    case apiKey = "api_key"
    case language = "language"
    case page = "page"
}

enum TMDBEndpoinRouter: URLRequestConvertible {
    
    case getPopularMovies(_ page: Int)
    case getMovie(_ id: Int)
    case getImage(_ path: String)
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseUrl.asURL()
        url = url.appendingPathComponent(AppCongfig.v3.rawValue)
        url = url.appendingPathComponent(path)
        url = url.appending(queryItems: [URLQueryItem(name:QueryComponents.apiKey.rawValue, value: AppCongfig.apiKey)])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(URLComponents.json.rawValue, forHTTPHeaderField: URLComponents.contentType.rawValue)
        urlRequest.setValue(URLComponents.json.rawValue, forHTTPHeaderField: URLComponents.accept.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var baseUrl: String {
        switch self {
        case .getImage(_):
            return AppCongfig.baseImageUrl.rawValue
        default:
            return AppCongfig.baseURL.rawValue
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getPopularMovies(_), .getMovie(_), .getImage(_):
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getPopularMovies:
            return "/movie/popular"
        case .getMovie(let id):
            return "/movie/\(id)"
        case .getImage(let path):
            return "/t/p/w500\(path)"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getPopularMovies(let page):
            return [QueryComponents.page.rawValue : page]
        default:
            return nil
        }
    }
}
