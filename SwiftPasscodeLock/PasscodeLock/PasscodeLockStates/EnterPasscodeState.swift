//
//  EnterPasscodeState.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/16/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class EnterPasscodeState: PasscodeLockState {
    
    public let title: String
    public let description: String
    public weak var passcodeLock: PasscodeLock?
    public weak var stateFactory: PasscodeLockStateFactory?
    
    private let passcodeRepository: PasscodeRepository
    
    init(passcodeRepository repository: PasscodeRepository) {
        
        passcodeRepository = repository
        
        title = NSLocalizedString(
            "PasscodeLockEnterTitle",
            tableName: "PasscodeLock",
            bundle: getLocalizationBundle(),
            comment: ""
        )
        
        description = NSLocalizedString(
            "PasscodeLockEnterDescription",
            tableName: "PasscodeLock",
            bundle: getLocalizationBundle(),
            comment: ""
        )
        
    }
    
    public func verifyPasscode() {
        
        if let lock = passcodeLock {
            
            if lock.passcode == passcodeRepository.getPasscode() {
                
                lock.delegate?.passcodeLockDidSucceed(lock)
                
            } else {
                
                lock.delegate?.passcodeLockDidFailed(lock)
            }
        }
        
    }
}
