//
//  KeychainItem.swift
//  SwiftKeychain
//
//  Created by Yanko Dimitrov on 11/11/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol KeychainItem {
    
    var name: String {get}
    
    /**
        Make a KeychainQuery for the specified KeychainService
        
        :param: keychain - KeychainService instance
    */
    func makeQueryForKeychain(keychain: KeychainService) -> KeychainQuery
    
    /**
        Returns a dictionary wtih the Keychain fields and their values
        that will be saved in the Keychain.
        
        :returns: dictionary
    */
    func fieldsToLock() -> NSDictionary
    
    /**
        Decodes the obtained from the Keychain data
        
        :param: data - the NSData stored in the Keychain
    */
    func unlockData(data: NSData)
}


/**
    BaseKey
*/
public class BaseKey: KeychainItem {
    
    private let keyName: String
    
    public var name: String {
        
        return keyName
    }
    
    init(name: String) {
        
        keyName = name
    }
    
     public func makeQueryForKeychain(keychain: KeychainService) -> KeychainQuery {
        
        assertionFailure("should be overridden in subclass")
        
        return KeychainQuery(keychain: keychain)
    }
    
    public func fieldsToLock() -> NSDictionary {
        
        assertionFailure("should be overridden in subclass")
        
        return NSDictionary()
    }
    
    public func unlockData(data: NSData) {
        
        assertionFailure("should be overridden in subclass")
    }
}
