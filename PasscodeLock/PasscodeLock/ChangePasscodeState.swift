//
//  ChangePasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct ChangePasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init() {
        
        title = localizedStringFor("PasscodeLockChangeTitle", comment: "Change passcode title")
        description = localizedStringFor("PasscodeLockChangeDescription", comment: "Change passcode description")
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        guard let currentPasscode = lock.repository.passcode else {
            return
        }
        
        if passcode == currentPasscode {
            
            let nextState = SetPasscodeState()
            
            lock.changeStateTo(nextState)
            
        } else {
            
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
