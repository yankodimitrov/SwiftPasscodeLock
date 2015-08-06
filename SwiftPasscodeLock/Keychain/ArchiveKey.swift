//
//  ArchiveKey.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/13/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class ArchiveKey: BaseKey {
    
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
        
        self.object = object
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
        
        object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSCoding
    }
}
