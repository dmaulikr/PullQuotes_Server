//
//  RequestVerificationMiddleware.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 8/3/17.
//
//

import Vapor

final class RequestVerificationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard request.headers.contentType == "application/json"  else {
            throw Abort(.badRequest, reason: "Server only accepts JSON content")
        }
        
        guard request.headers.accessToken == "1"  else {
            throw Abort(.forbidden, reason: "No access token")
        }
        
        // TODO: do something with the accesstoken
        // -- needs to actually match the user's access token
        
        return try next.respond(to: request)
    }
    
}
