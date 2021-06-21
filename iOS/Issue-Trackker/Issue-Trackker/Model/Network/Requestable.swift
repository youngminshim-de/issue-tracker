//
//  EndPoint.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/13.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    func url() -> URL?
}

class MainRequest: Requestable {
    
    var baseURL: String
    var path: String
    var httpMethod: HTTPMethod
    
    init(baseURL: String, path: String, httpMethod: HTTPMethod) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
    }
    
    func url() -> URL? {
        return URL(string: baseURL + path)
    }
}

class LocalRequest: Requestable {
    
    var baseURL: String
    var path: String
    var httpMethod: HTTPMethod
    
    init(baseURL: String, path: String, httpMethod: HTTPMethod) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
    }
    
    func url() -> URL? {
        URL(fileURLWithPath: baseURL + path)
    }
}

enum EndPoint: CustomStringConvertible {
    case baseURL
    case IssueListEndPoint
    case IssueDetailEndPoint
    
    var description: String {
        switch self{
        case .baseURL:
            return "http://3.35.2.191/"
        case .IssueListEndPoint:
            return "http://3.35.2.191/issues"
        case .IssueDetailEndPoint:
            return "http://3.35.2.191/issues/"
        }
    }
}
