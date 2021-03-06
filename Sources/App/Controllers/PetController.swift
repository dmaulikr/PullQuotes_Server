//
//  PetController.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/16/17.
//
//

import Foundation
import Vapor

final class PetController: ResourceRepresentable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    func makeResource() -> Resource<Pet> {
        return Resource(
            index: self.index,
            store: self.create,
            show: self.show,
            update: self.update,
            destroy: self.delete
        )
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Helper Methods
    
    /**
     When users call `GET` on `/pets` it should return an index of all available resources
     */
    func index(request: Request) throws -> ResponseRepresentable {
        return try Pet.all().makeJSON()
    }
    
    /**
     When consumers call 'POST' on '/pets' with valid JSON create and save the resource
     */
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        let pet = try Pet(json: json)
        try pet.save()
        return pet
    }
    
    /**
     When the consumer calls `GET` on a specific resource (i.e. `/pets/13rd88`)
     */
    func show(request: Request, pet: Pet) throws -> ResponseRepresentable {
        return pet
    }
    
    /**
     When the user calls 'PATCH' on a specific resource, we should update that resource to the new values
     */
    func update(request: Request, pet: Pet) throws -> ResponseRepresentable {
        try pet.update(for: request)
        try pet.save()
        return pet
    }
    
    /**
     When the consumer calls `DELETE` on a specific resource
     */
    func delete(request: Request, pet: Pet) throws -> ResponseRepresentable {
        try pet.delete()
        var jsonResponse = JSON()
        try jsonResponse.set("message", "successfully deleted")
        return try Response(status: .ok, json: jsonResponse)
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension PetController: EmptyInitializable { }
