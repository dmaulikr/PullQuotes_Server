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
            destroy: self.delete //DELETE
        )
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Helper Methods
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try PullQuote.all().makeJSON()
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        let pq = try PullQuote(json: json)
        try pq.save()
        return pq
    }
    
    func show(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        return pullQuote
    }
    
    func update(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        try pullQuote.update(for: request)
        try pullQuote.save()
        return pullQuote
        //TODO: what if i want to update a property to nil?
    }
    
    func delete(request: Request, pullQuote: PullQuote) throws -> ResponseRepresentable {
        try pullQuote.delete()
        var json = JSON()
        try json.set("message", "successfully deleted")
        return try Response(status: .ok, json: json)
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuoteController: EmptyInitializable { }