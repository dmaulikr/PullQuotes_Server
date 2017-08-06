//
//  User.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 8/3/17.
//
//

import Vapor
import FluentProvider
import AuthProvider

final class User: Model {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    var iCloudId: String
    var firstName: String?
    var lastName: String?
    var email: String?
    
    static let iCloudIdKey = "icloud_id"
    static let firstNameKey = "first_name"
    static let lastNameKey = "last_name"
    static let emailKey = "email"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.iCloudId = try row.get(User.iCloudIdKey)
        self.firstName = try row.get(User.firstNameKey)
        self.lastName = try row.get(User.lastNameKey)
        self.email = try row.get(User.emailKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.iCloudIdKey, self.iCloudId)
        try row.set(User.firstNameKey, self.firstName)
        try row.set(User.lastNameKey, self.lastName)
        try row.set(User.emailKey, self.email)
        return row
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension User: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { user in
            user.id()
            user.string(User.iCloudIdKey)
            user.string(User.firstNameKey, optional: true)
            user.string(User.lastNameKey, optional: true)
            user.string(User.emailKey, optional: true)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension User: TokenAuthenticatable {
    
    /// the token model that should be queried to authenticate this user
    public typealias TokenType = Token
    
}
