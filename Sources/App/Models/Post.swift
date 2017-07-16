import Vapor
import FluentProvider
import HTTP

final class Post: Model, Timestampable {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Properties
    
    let storage = Storage()
    
    var content: String // The content of the post
    
    static let idKey = "id" // The column names for `id` in the database
    static let contentKey = "content" // The column names for `content` in the database
    
    //---------------------------------------------------------------------------------------
    //MARK: - Init
    
    init(content: String) {
        self.content = content
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Fluent Serialization

    /**
     Initializes the Post from the database row
     */
    init(row: Row) throws {
        content = try row.get(Post.contentKey)
    }

    /**
     Serializes the Post to the database
     */
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Post.contentKey, content)
        return row
    }
}

//-------------------------------------------------------------------------------------------
//MARK: - Fluent Preparation

extension Post: Preparation {
    
    /**
     Prepares a table/collection in the database for storing Posts
     */
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Post.contentKey)
        }
    }

    /**
     Undoes what was done in `prepare`
     */
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

//-------------------------------------------------------------------------------------------
//MARK: - JSON

/**
 How the model converts from / to JSON.
 */
extension Post: JSONConvertible {
   
    /**
     Creating a new Post (POST /posts)
     */
    convenience init(json: JSON) throws {
        try self.init(
            content: json.get(Post.contentKey)
        )
    }
    
    /**
     Fetching a post (GET /posts, GET /posts/:id)
     */
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Post.idKey, id)
        try json.set(Post.contentKey, content)
        try json.set(Post.updatedAtKey, updatedAt)
        try json.set(Post.createdAtKey, createdAt)
        return json
    }
}

//-------------------------------------------------------------------------------------------
//MARK: - HTTP

/**
 This allows Post models to be returned directly in route closures
 */
extension Post: ResponseRepresentable { }

//-------------------------------------------------------------------------------------------
//MARK: - Update

/**
 This allows the Post model to be updated dynamically by the request.
 */
extension Post: Updateable {
    
    // Updateable keys are called when `post.update(for: req)` is called. Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Post>] {
        return [
            
            // If the request contains a String at key "content" the setter callback will be called.
            UpdateableKey(Post.contentKey, String.self) { post, content in
                post.content = content
            }
        ]
    }
}
