//
//  Config+Setup.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/9/17.
//
//

import AuthProvider
import FluentProvider
import PostgreSQLProvider

extension Config {
    
    //---------------------------------------------------------------------------------------
    //MARK: - Public Methods
    
    public func setup() throws {
        
        // allow fuzzy conversions for these types (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try configureMiddleware()
        try configureProviders()
        try configureSchemas()
    }
    
    //---------------------------------------------------------------------------------------
    //MARK: - Private Methods
    
    private func configureMiddleware() throws {
        self.addConfigurable(middleware: RedirectMiddleware.login(), name: "redirect")
    }
    
    private func configureSchemas() throws {
        self.preparations.append(User.self)
        self.preparations.append(Token.self)
        self.preparations.append(PullQuote.self)
        self.preparations.append(Tag.self)
        self.preparations.append(Pivot<PullQuote, Tag>.self)
    }
    
    private func configureProviders() throws {
        try self.addProvider(FluentProvider.Provider.self)
        try self.addProvider(PostgreSQLProvider.Provider.self)
    }
    
}
