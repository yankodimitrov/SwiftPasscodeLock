//
//  FakePasscodeLockConfiguration.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeLockConfiguration: PasscodeLockConfigurationType {
    
    let repository: PasscodeRepositoryType
    let passcodeLength = 4
    var isTouchIDAllowed = false
    let maximumInccorectPasscodeAttempts = 3
    let shouldRequestTouchIDImmediately = false
    
    init(repository: PasscodeRepositoryType) {
        
        self.repository = repository
    }
}
