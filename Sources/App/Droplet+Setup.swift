@_exported import Vapor

extension Droplet {
    
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
    }
    
}

extension Droplet {
    
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain with a description of the request
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
        
        get("pets") { request in
            return try Pet.all().description
        }
        
        post("hello") { request in
            guard let name = request.data["name"]?.string else {
                throw Abort(.badRequest, reason: "wrong body")
            }
            
            return "Hello \(name)"
        }
        
        try resource("posts", PostController.self)
        try resource("pets", PetController.self)
    }
    
}
