//
//  Pet.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/10/17.
//
//

import Vapor
import FluentProvider
import HTTP

final class Pet: Model, Timestampable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    var name: String
    var age: Int
    var breed: String?
    
    static let nameKey = "name"
    static let ageKey = "age"
    static let breedKey = "breed"
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(row: Row) throws {
        self.name = try row.get(Pet.nameKey)
        self.age = try row.get(Pet.ageKey)
        self.breed = try row.get(Pet.breedKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Pet.nameKey, self.name)
        try row.set(Pet.ageKey, self.age)
        try row.set(Pet.breedKey, self.breed)
        return row
    }
    
    init(name: String, age: Int, breed: String?) {
        self.name = name
        self.age = age
        self.breed = breed
    }
    
}

//-------------------------------------------------------------------------------------------
//MARK: - Extensions

extension Pet: Preparation {
    
    /**
     Prepares a table/collection in the database for storing Posts
     */
    static func prepare(_ database: Database) throws {
        try database.create(self) { pets in
            pets.id()
            pets.string(Pet.nameKey)
            pets.int(Pet.ageKey)
            pets.string(Pet.breedKey, optional: true)
        }
    }

    /**
     Undoes what was done in `prepare`
     */
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

/**
 How the model converts from / to JSON.
 */
extension Pet: JSONConvertible {
    
    /**
     Creating a new pet (POST /posts)
     */
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Pet.nameKey),
            age: json.get(Pet.ageKey),
            breed: json.get(Pet.breedKey))
    }
    
    /**
     Fetching a pet (GET /posts, GET /posts/:id)
     */
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Pet.idKey, id)
        try json.set(Pet.updatedAtKey, updatedAt)
        try json.set(Pet.createdAtKey, createdAt)
        try json.set(Pet.nameKey, self.name)
        try json.set(Pet.ageKey, self.age)
        try json.set(Pet.breedKey, self.breed)
        return json
    }
    
}

/**
 This allows the Pet model to be updated dynamically by the request.
 */
extension Pet: Updateable {
    
    static var updateableKeys: [UpdateableKey<Pet>] {
        let name: UpdateableKey<Pet> = UpdateableKey(Pet.nameKey, String.self) { pet, updatedName in
            pet.name = updatedName
        }
        let age: UpdateableKey<Pet> = UpdateableKey(Pet.ageKey, Int.self) { pet, updatedAge in
            pet.age = updatedAge
        }
        let breed: UpdateableKey<Pet> = UpdateableKey(Pet.breedKey, String.self) { pet, updatedBreed in
            pet.breed = updatedBreed
        }
        return [name, age, breed]
    }
    
}

/**
 This allows Post models to be returned directly in route closures
 */
extension Pet: ResponseRepresentable { }
