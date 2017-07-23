//
//  PullQuote.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/23/17.
//
//

import Vapor
import FluentProvider
import HTTP

final class PullQuote: Model, Timestampable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    var quote: String
    var author: String
    var source: String?
//    var tags: [String]?
    
    static let quoteKey = "quote"
    static let authorKey = "author"
    static let sourceKey = "source"
//    static let tagsKey = "tags"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.quote = try row.get(PullQuote.quoteKey)
        self.author = try row.get(PullQuote.authorKey)
        self.source = try row.get(PullQuote.sourceKey)
//        self.tags = try row.get(PullQuote.tagsKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PullQuote.quoteKey, self.quote)
        try row.set(PullQuote.authorKey, self.author)
        try row.set(PullQuote.sourceKey, self.source)
//        try row.set(PullQuote.tagsKey, self.tags)
        return row
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuote: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { pullquote in
            pullquote.id()
            pullquote.string(PullQuote.quoteKey)
            pullquote.string(PullQuote.authorKey)
            pullquote.string(PullQuote.sourceKey, optional: true)
            // TODO: how to prep array of tags here?
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}
