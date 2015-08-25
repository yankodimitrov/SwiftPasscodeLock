//
//  ConfirmPasscodeState.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/18/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

public class ConfirmPasscodeState: PasscodeLockState {
    
    public let title: String
    public let description: String
    public weak var passcodeLock: PasscodeLock?
    public weak var stateFactory: PasscodeLockStateFactory?
    
    private let passcodeRepository: PasscodeRepository
    private let passcodeToConfirm: [String]
    
    init(passcode: [String], passcodeRepository repository: PasscodeRepository) {
        
        assert(passcode.count > 0, "Can't confirm an empty passcode!")
        
        passcodeToConfirm = passcode
        passcodeRepository = repository
        
        title = NSLocalizedString(
            "PasscodeLockConfirmTitle",
            tableName: "PasscodeLock",
            bundle: getLocalizationBundle(),
            comment: ""
        )
        
        description = NSLocalizedString(
            "PasscodeLockConfirmDescription",
            tableName: "PasscodeLock",
            bundle: getLocalizationBundle(),
            comment: ""
        )
        
    }
    
    public func verifyPasscode() {
        
        if let lock = passcodeLock {
        
            if lock.passcode == passcodeToConfirm {
                
                storePasscodeInRepository(lock.passcode)
                
                lock.delegate?.passcodeLockDidSucceed(lock)
                
            } else {
                
                lock.state = stateFactory?.makePasscodesMismatchState()
                lock.delegate?.passcodeLockDidFailed(lock)
            }
        }
    }
    
    private func storePasscodeInRepository(passcode: [String]) {
        
        if passcodeRepository.hasPasscode == true {
            
            passcodeRepository.updatePasscode(passcode)
            
        } else {
            
            passcodeRepository.savePasscode(passcode)
        }
        
    }
}
