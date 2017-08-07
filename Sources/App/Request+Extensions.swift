//
//  Request+Extensions.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 8/6/17.
//
//

import Vapor

extension Request {
    
    func userTokenFromAuthToken() throws -> Token? {
        let authToken = self.auth.header?.bearer
        let userToken = try Token.makeQuery().filter(Token.tokenKey, authToken?.string).first()
        return userToken
    }
    
}
