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
    
    init(quote: String, author: String, source: String?) {
        self.quote = quote
        self.author = author
        self.source = source
        //TODO: tags array
    }
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuote: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { pq in
            pq.id()
            pq.string(PullQuote.quoteKey)
            pq.string(PullQuote.authorKey)
            pq.string(PullQuote.sourceKey, optional: true)
            // TODO: how to prep array of tags here?
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension PullQuote: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(quote: json.get(PullQuote.quoteKey),
                  author: json.get(PullQuote.authorKey),
                  source: json.get(PullQuote.sourceKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PullQuote.idKey, self.id)
        try json.set(PullQuote.updatedAtKey, self.updatedAt)
        try json.set(PullQuote.createdAtKey, self.createdAt)
        try json.set(PullQuote.quoteKey, self.quote)
        try json.set(PullQuote.authorKey, self.author)
        try json.set(PullQuote.sourceKey, self.author)
        //TODO: tags array
        return json
    }
    
}

extension PullQuote: Updateable {
    
    static var updateableKeys: [UpdateableKey<PullQuote>] {
        let quote: UpdateableKey<PullQuote> = UpdateableKey(PullQuote.quoteKey, String.self) { pq, updatedQuote in
            pq.quote = updatedQuote
        }
        let author: UpdateableKey<PullQuote> = UpdateableKey(PullQuote.authorKey, String.self) { pq, updatedAuthor in
            pq.author = updatedAuthor
        }
        let source: UpdateableKey<PullQuote> = UpdateableKey(PullQuote.sourceKey, String.self) { pq, updatedSource in
            pq.source = updatedSource
        }
        //TODO: tags array
        return [quote, author, source]
    }
    
}
