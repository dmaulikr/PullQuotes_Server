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
    var tags: Siblings<PullQuote, Tag, Pivot<PullQuote, Tag>> {
        return siblings()
    }
    var tagArray: [String]?
    
    var userId: Identifier?
    var user: Parent<PullQuote, User> {
        return parent(id: self.userId)
    }
    
    static let quoteKey = "quote"
    static let authorKey = "author"
    static let sourceKey = "source"
    static let tagsKey = "tags"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.quote = try row.get(PullQuote.quoteKey)
        self.author = try row.get(PullQuote.authorKey)
        self.source = try row.get(PullQuote.sourceKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PullQuote.quoteKey, self.quote)
        try row.set(PullQuote.authorKey, self.author)
        try row.set(PullQuote.sourceKey, self.source)
        try row.set(User.foreignIdKey, self.userId)
        return row
    }
    
    init(quote: String, author: String, source: String?, tags: [String]?) {
        self.quote = quote
        self.author = author
        self.source = source
        self.tagArray = tags
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Relationship Methods
    
    func setParent(from request: Request) throws {
        let userId = try request.userTokenFromAuthToken()?.id
        self.userId = userId
    }
    
    func saveTags() throws {
        guard let tags = self.tagArray else { return }
        try tags.forEach {
            var tag = Tag(name: $0)
            let query = try Tag.makeQuery().filter(Tag.nameKey, .equals, tag.name)
            if let existingTag = try query.first() {
                tag = existingTag
            } else {
                try tag.save()
            }
            
            let pivot = try Pivot<PullQuote, Tag>(self, tag)
            try pivot.save()
        }
    }
    
    func removeTags() throws {
        let currentTags = try self.tags.all()
        for tag in currentTags {
            try self.tags.remove(tag)
        }
    }
    
    func updateTags() throws {
        try self.removeTags()
        try self.saveTags()
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuote: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { pq in
            pq.id()
            pq.string(PullQuote.quoteKey, length: 1500)
            pq.string(PullQuote.authorKey)
            pq.string(PullQuote.sourceKey, optional: true)
            pq.parent(User.self)
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
                  source: json.get(PullQuote.sourceKey),
                  tags: json.get(PullQuote.tagsKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PullQuote.idKey, self.id)
        try json.set(PullQuote.updatedAtKey, self.updatedAt)
        try json.set(PullQuote.createdAtKey, self.createdAt)
        try json.set(PullQuote.quoteKey, self.quote)
        try json.set(PullQuote.authorKey, self.author)
        try json.set(PullQuote.sourceKey, self.source)
        try json.set(PullQuote.tagsKey, try self.tags.all().makeJSON())
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
        return [quote, author, source]
    }
    
}

extension PullQuote: ResponseRepresentable { }
