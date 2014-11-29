//
//  ChangePasscodeState.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/18/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class ChangePasscodeState: PasscodeLockState {
    
    public let title: String
    public let description: String
    public weak var passcodeLock: PasscodeLock?
    public weak var stateFactory: PasscodeLockStateFactory?
    
    private let passcodeRepository: PasscodeRepository
    
    init(passcodeRepository repository: PasscodeRepository) {
        
        passcodeRepository = repository
        
        title = NSLocalizedString(
            "PasscodeLockChangeTitle",
            tableName: "PasscodeLock",
            comment: ""
        )
        
        description = NSLocalizedString(
            "PasscodeLockChangeDescription",
            tableName: "PasscodeLock",
            comment: ""
        )
        
    }
    
    public func verifyPasscode() {
        
        if let lock = passcodeLock {
            
            if lock.passcode == passcodeRepository.getPasscode() {
                
                lock.state = stateFactory?.makeSetPasscodeState()
                lock.resetSigns()
                
            } else {
                
                lock.delegate?.passcodeLockDidFailed(lock)
            }
        }
        
    }
}
