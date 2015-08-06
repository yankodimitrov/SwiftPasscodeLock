//
//  GenericKey.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/12/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class GenericKey: BaseKey {
    
    public var value: NSString?
    
    private var secretData: NSData? {
        
        return value?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(keyName: String, value: String? = nil) {
        
        self.value = value
        super.init(name: keyName)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - KeychainItem
    ///////////////////////////////////////////////////////
    
    public override func makeQueryForKeychain(keychain: KeychainService) -> KeychainQuery {
        
        let query = KeychainQuery(keychain: keychain)
        
        query.addField(kSecClass as String, withValue: kSecClassGenericPassword)
        query.addField(kSecAttrService as String, withValue: keychain.serviceName)
        query.addField(kSecAttrAccount as String, withValue: name)
        
        return query
    }
    
    public override func fieldsToLock() -> NSDictionary {
        
        var fields = NSMutableDictionary()
        
        if let data = secretData {
            
            fields[kSecValueData as String] = data
        }
        
        return fields
    }
    
    public override func unlockData(data: NSData) {
        
        value = NSString(data: data, encoding: NSUTF8StringEncoding)
    }
}
