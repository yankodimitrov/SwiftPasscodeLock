//
//  SetPasscodeState.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/18/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class SetPasscodeState: PasscodeLockState {
    
    public let title: String
    public let description: String
    public weak var passcodeLock: PasscodeLock?
    public weak var stateFactory: PasscodeLockStateFactory?
    
    init() {
        
        title = NSLocalizedString(
            "PasscodeLockSetTitle",
            tableName: "PasscodeLock",
            comment: ""
        )
        
        description = NSLocalizedString(
            "PasscodeLockSetDescription",
            tableName: "PasscodeLock",
            comment: ""
        )
        
    }
    
    public func verifyPasscode() {
        
        if let lock = passcodeLock {
            
            lock.state = stateFactory?.makeConfirmPasscodeState()
            lock.resetSigns()
        }
        
    }
}
