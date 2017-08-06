//
//  Droplet+Setup.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/9/17.
//
//

@_exported import Vapor
import AuthProvider

extension Droplet {
    
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
    }
    
}

extension Droplet {
    
    func setupRoutes() throws {
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let groupV1Auth = self.grouped("v1").grouped([tokenMiddleware])
        try groupV1Auth.resource("quotes", PullQuoteController.self)
        
        get("login") { req in
            var json = JSON()
            try json.set("redirect", "login required - create user or refresh token here")
            return json
        }
        
        get("hello") { req in
            return "Hello, world!"
        }
        
        get("info") { req in
            return req.description
        }
        
        get("description") { request in
            guard let accessToken = request.headers.accessToken else {
                throw Abort(.badRequest, reason: "No access token")
            }
            
            print("accessToken: \(accessToken)")
            return request.description
        }
        
        post("hello") { request in
            guard let name = request.data["name"]?.string else {
                throw Abort(.badRequest, reason: "wrong body")
            }
            
            return "Hello \(name)"
        }
        
        try resource("posts", PostController.self)
        try resource("pets", PetController.self)
        
        get("pets") { request in
            return try Pet.all().description
        }
    }
    
}
