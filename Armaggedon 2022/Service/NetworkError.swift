//
//  NetworkError.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 13.04.2022.
//

import Foundation
import Alamofire

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var code: Int
    var httpError: String
    var errorMessage: String
    var request: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case httpError = "http_error"
        case errorMessage = "errorMessage"
        case request = "request"
    }
}
