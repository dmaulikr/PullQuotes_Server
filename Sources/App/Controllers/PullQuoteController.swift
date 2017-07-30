//
//  PullQuoteController.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/23/17.
//
//

import Foundation
import Vapor

final class PullQuoteController: ResourceRepresentable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    func makeResource() -> Resource<PullQuote> {
        return Resource(
            index: self.index, //GET
            store: self.create, //POST
            show: self.show, //GET
            update: self.update, //PATCH
            replace: self.replace, //PUT
            destroy: self.delete //DELETE
        )
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Resource Methods
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try PullQuote.all().makeJSON()
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        let pq = try PullQuote(json: json)
        try pq.save()
        try pq.saveNewTags()
        return pq
    }
    
    func show(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        return pullQuote
    }
    
    func update(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        try pullQuote.update(for: request)
        try pullQuote.save()
        return pullQuote
    }
    
    func replace(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        let new = try PullQuote(json: json)
        pullQuote.quote = new.quote
        pullQuote.author = new.author
        pullQuote.source = new.source
        pullQuote.tagArray = new.tagArray
        try pullQuote.save()
        try pullQuote.updateTags()
        return pullQuote
    }
    
    func delete(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        try pullQuote.removeTags()
        try pullQuote.delete()
        var json = JSON()
        try json.set("message", "successfully deleted")
        return try Response(status: .ok, json: json)
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuoteController: EmptyInitializable { }
