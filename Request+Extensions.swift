//
//  Request+Extensions.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/16/17.
//
//

import Vapor
import HTTP

extension Request {
    
    /**
     Create a post from the JSON body return BadRequest error if invalid or no JSON
     */
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(json: json)
    }
    
}
