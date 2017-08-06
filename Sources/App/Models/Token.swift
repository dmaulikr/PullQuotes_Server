//
//  Token.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 8/4/17.
//
//

import Vapor
import FluentProvider

final class Token: Model, Timestampable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    var token: String
    var userId: Identifier
    var user: Parent<Token, User> {
        return parent(id: self.userId)
    }
    
    static let tokenKey = "token"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.token = try row.get(Token.tokenKey)
        self.userId = try row.get(Token.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.tokenKey, self.token)
        try row.set(Token.identifier, self.userId)
        return row
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension Token: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { token in
            token.id()
            token.string(Token.tokenKey)
            token.parent(User.self)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
