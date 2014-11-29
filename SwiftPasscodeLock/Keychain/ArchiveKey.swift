//
//  ArchiveKey.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/13/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class ArchiveKey: KeychainItem {
    
    public let name: String
    public var object: NSCoding?
    
    private var secretData: NSData? {
        
        if let objectToArchive = object {
            
            return NSKeyedArchiver.archivedDataWithRootObject(objectToArchive)
        }
        
        return nil
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(keyName: String, object: NSCoding? = nil) {
        
        name = keyName
        self.object = object
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
        
        object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSCoding
    }
}
