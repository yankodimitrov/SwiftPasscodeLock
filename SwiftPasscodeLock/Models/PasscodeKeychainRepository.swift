//
//  PasscodeKeychainRepository.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/16/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class PasscodeKeychainRepository: PasscodeRepository {
    
    public var hasPasscode: Bool {
        return getPasscode().count > 0
    }
    
    private let keychain: KeychainService
    private let keyName = "passcode"
    
    ///////////////////////////////////////////////////////
    // MARK: - Initializers
    ///////////////////////////////////////////////////////
    
    init(keychainService: KeychainService) {
        
        keychain = keychainService
    }
    
    convenience init() {
        
        let keychain = Keychain(serviceName: "swift.passcode.lock", accessMode: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
        
        self.init(keychainService: keychain)
    }
    
    ///////////////////////////////////////////////////////
    // MARK: - Methods
    ///////////////////////////////////////////////////////
    
    public func savePasscode(passcode: [String]) -> Bool {
        
        let passcodeKey = ArchiveKey(keyName: keyName, object: passcode)
        
        if let error = keychain.add(passcodeKey) {
            
            return false
        }
        
        return true
    }
    
    public func updatePasscode(passcode: [String]) -> Bool {
        
        let passcodeKey = ArchiveKey(keyName: keyName, object: passcode)
        
        if let error = keychain.update(passcodeKey) {
            
            return false
        }
        
        return true
    }
    
    public func deletePasscode() -> Bool {
        
        let passcodeKey = ArchiveKey(keyName: keyName)
        
        if let error = keychain.remove(passcodeKey) {
            
            return false
        }
        
        return true
    }
    
    public func getPasscode() -> [String] {
        
        var passcodeStack = [String]()
        let passcodeKey = ArchiveKey(keyName: keyName)
        
        if let passcode = keychain.get(passcodeKey).item?.object as? NSArray {
            
            for item in passcode {
                let sign = item as! String
                
                passcodeStack.append(sign)
            }
        }
        
        return passcodeStack
    }
}
