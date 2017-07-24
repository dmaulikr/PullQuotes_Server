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
            index: self.index,
            store: self.create
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
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PullQuoteController: EmptyInitializable { }
