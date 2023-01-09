//
//  NetworkError.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import Foundation

enum HttpStatus: Error {
    case badRequest
    case unauthorized
    case undefined
}

struct NetworkError: Error {
    func returnError(rawValue: Int) -> Error {
        switch rawValue {
        case 400:
            return HttpStatus.badRequest
        case 401:
            return HttpStatus.unauthorized
        default:
            return HttpStatus.undefined
        }
    }
}

extension HttpStatus: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Server cannot process the request due to some client error"
        case .unauthorized:
            return "The request has not been applied because it lacks valid authentication credentials for the target resource"
        case .undefined:
            return "The error code cannot be identified"
        }
    }
}
