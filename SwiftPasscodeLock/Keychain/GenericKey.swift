//
//  GenericKey.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/12/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class GenericKey: KeychainItem {
    
    public let name: String
    public var value: NSString?
    
    private var secretData: NSData? {
        
        return value?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(keyName: String, value: String? = nil) {
        
        name = keyName
        self.value = value
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - KeychainItem
    ///////////////////////////////////////////////////////
    
    public func makeQueryForKeychain(keychain: KeychainService) -> KeychainQuery {
        
        let query = KeychainQuery(keychain: keychain)
        
        query.addField(kSecClass, withValue: kSecClassGenericPassword)
        query.addField(kSecAttrService, withValue: keychain.serviceName)
        query.addField(kSecAttrAccount, withValue: name)
        
        return query
    }
    
    public func fieldsToLock() -> NSDictionary {
        
        var fields = NSMutableDictionary()
        
        if let data = secretData {
            
            fields[kSecValueData as String] = data
        }
        
        return fields
    }
    
    public func unlockData(data: NSData) {
        
        value = NSString(data: data, encoding: NSUTF8StringEncoding)
    }
}
