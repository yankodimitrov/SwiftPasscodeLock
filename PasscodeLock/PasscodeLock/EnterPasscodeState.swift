//
//  EnterPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct EnterPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = false
    var isTouchIDAllowed = true
    
    init() {
        
        title = "Enter Passcode"
        description = "Enter your passcode"
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        guard let currentPasscode = lock.repository.passcode else {
            assertionFailure("There is no saved passcode to enter")
            return
        }
        
        if passcode == currentPasscode {
            
            lock.delegate?.passcodeLockDidSucceed(lock)
            
        } else {
            
            lock.delegate?.passcodeLockDidFailed(lock)
        }
    }
}
