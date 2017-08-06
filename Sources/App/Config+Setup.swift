import AuthProvider
import FluentProvider
import PostgreSQLProvider

extension Config {
    
    public func setup() throws {
        
        // allow fuzzy conversions for these types (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupMiddleware()
        try setupModelSchemas()
        try setupProviders()
    }
    
    private func setupMiddleware() throws {
        self.addConfigurable(middleware: RedirectMiddleware.login(), name: "redirect")
    }
    
    private func setupModelSchemas() throws {
        self.preparations.append(Post.self)
        self.preparations.append(Pet.self)
        self.preparations.append(PullQuote.self)
        self.preparations.append(Tag.self)
        self.preparations.append(Pivot<PullQuote, Tag>.self)
    }
    
    private func setupProviders() throws {
        try self.addProvider(FluentProvider.Provider.self)
        try self.addProvider(PostgreSQLProvider.Provider.self)
    }
    
}
