//
//  NetworkWorker.swift
//  MTest
//
//  Created by Amit  Chakradhari on 10/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation
import Alamofire

class NetworkWorker {
    
    var session: Session
    
    init(session: Session = AF) {
        self.session = session
    }
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        session.request(ApiRouter.getusers)
            .validate()
            .responseData { response in
                
                switch response.result {
                case .success:
                    if let responseData = response.data {
                        do {
                            let users = try JSONDecoder().decode([User].self, from: responseData)
                            completion(.success(users))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
        }
    }
}

fileprivate enum ApiRouter: URLRequestConvertible {
    
    case getusers
    
    var baseUrl: String {
        switch self {
        case .getusers:
            return "https://jsonplaceholder.typicode.com"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getusers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getusers:
            return "/users"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: nil)
    }
}


