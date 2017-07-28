//
//  HTTP+Extensions.swift
//  PullQuotes_Server
//
//  Created by Daniel Hour on 7/9/17.
//
//

import Vapor
import HTTP

extension HTTP.KeyAccessible where Key == HeaderKey, Value == String {
    var accessToken: String? {
        get {
            return self["x-access-token"]
        }
        set {
            self["x-access-token"] = newValue
        }
    }
}
