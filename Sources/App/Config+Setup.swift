import FluentProvider
import PostgreSQLProvider

extension Config {
    
    public func setup() throws {
        
        // allow fuzzy conversions for these types (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /**
     Configure providers
     */
    private func setupProviders() throws {
        try self.addProvider(FluentProvider.Provider.self)
        try self.addProvider(PostgreSQLProvider.Provider.self)
    }
    
    /**
     Add all models that should have their schemas prepared before the app boots
     */
    private func setupPreparations() throws {
        self.preparations.append(Post.self)
        self.preparations.append(Pet.self)
        self.preparations.append(PullQuote.self)
    }
}
