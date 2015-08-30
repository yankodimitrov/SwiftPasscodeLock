//
//  ConfirmPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct ConfirmPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    private var passcodeToConfirm: [String]
    
    init(passcode: [String]) {
        
        passcodeToConfirm = passcode
        title = localizedStringFor("PasscodeLockConfirmTitle", comment: "Confirm passcode title")
        description = localizedStringFor("PasscodeLockConfirmDescription", comment: "Confirm passcode description")
    }
    
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        if passcode == passcodeToConfirm {
            
            lock.repository.savePasscode(passcode)
            lock.delegate?.passcodeLockDidSucceed(lock)
        
        } else {
            
            let mismatchTitle = localizedStringFor("PasscodeLockMismatchTitle", comment: "Passcode mismatch title")
            let mismatchDescription = localizedStringFor("PasscodeLockMismatchDescription", comment: "Passcode mismatch description")
            
            let nextState = SetPasscodeState(title: mismatchTitle, description: mismatchDescription)
            
            lock.changeStateTo(nextState)
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
