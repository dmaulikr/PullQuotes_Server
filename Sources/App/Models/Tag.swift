//
//  Tag.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/27/17.
//
//

import Vapor
import FluentProvider
import HTTP

final class Tag: Model {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    let name: String
    
    static let nameKey = "name"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.name = try row.get(Tag.nameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Tag.nameKey, self.name)
        return row
    }
    
    init(name: String) {
        self.name = name
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension Tag: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { tag in
            tag.id()
            tag.string(Tag.nameKey)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Tag: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Tag.nameKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Tag.idKey, self.id)
        try json.set(Tag.nameKey, self.name)
        return json
    }
}
